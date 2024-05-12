//
//  MypageViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/21/24.
//

import UIKit

import Kingfisher
import FirebaseDatabase

enum MyPageError: Error {
  case imageURLNotFound
}

protocol myPostedDataConfigurable {
  func configure(with data: CreatePostModel)
}

class MypageViewModel: CommonViewModel {
  let createViewModel = CreatePostViewModel.shared
  static let shared = MypageViewModel()
  
  // 받아와야할 것 - 1.해당 월 전체(데이터 있으면 표시 없으면 냅두기), 2. 선택한 날짜의 데이터 뿌려주기
  // uid를 매개변수로 따로 빼서 값이 들어오면 상대방 없으면 내꺼
  func getMyInfomation(checkMyUid: Bool = true,
                       otherPersonUid: String = "",
                       completion: @escaping(UserModel) -> Void){
    let userUid = checkMyUid == true ? uid : otherPersonUid
    ref.child("UserDataInfo").child(userUid ?? "").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else { return }
      guard let userData = self.convertUserModel(data: value) else { return}
      completion(userData)
    }
  }
  
  func fetchDailyData(checkOtherMonth: Bool = false,
                      year: String = "",
                      month: String = "",
                      _ selectedDay: String,
                      completion: @escaping ([String: Any]?) -> Void) {
    let startDate = checkOtherMonth ? [year, month] : getStartDate()
    let changedRef = ref.child("History").child(uid!).child(startDate[0]).child(startDate[1])
    
    changedRef.child(selectedDay).observeSingleEvent(of: .value) { snapshot in
      completion(snapshot.value as? [String: Any])
    }
  }

  // MARK: - 달력 데이터 가져오기
  func getMyWorkoutHistory(checkMoveMonth: Bool = false,
                           year: String = "",
                           month: String = "" ,
                           completion: @escaping (([Int]) -> Void)){
    var monthlyWorkoutCheck: [Int] = []
    fetchThisMonthData(checkMoveMonth: checkMoveMonth,
                       year: year,
                       month: month) { monthlyData in
      guard let monthlyData = monthlyData else {
        completion(monthlyWorkoutCheck)
        return
      }
      for dayOffset in 1..<31 {
        if let workoutData = self.convertToHistoryModelWithDate(for: "\(dayOffset)",
                                                                data: monthlyData) {
          monthlyWorkoutCheck.append(dayOffset)
        }
      }
      completion(monthlyWorkoutCheck)
    }
  }
  
  // MARK: - 달력에서 데일리 데이터 가져오기
  func getDailyHistory(checkOtherMonth: Bool = false,
                       year: String = "",
                       month: String = "",
                       _ selectedDay: String,
                       completion: @escaping (HistoryModel) -> Void) {
    fetchDailyData(checkOtherMonth: checkOtherMonth,
                   year: year,
                   month: month,
                   selectedDay) { result in
      guard let result = result else {
        let emptyValue = HistoryModel(comment: "기록없음", date: "기록없음", rate: 0.0,
                                      together: "기록없음", workoutTypes: ["기록없음"])
        completion(emptyValue)
        return
      }
      guard let workoutData = self.convertToHistoryModel(data: result) else { return }
      completion(workoutData)
    }
  }
  
  func getMyPostData(completion: @escaping ([String: Any]) -> Void){
    ref.child("users").child(uid ?? "").child("posts").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        return
      }
      completion(value)
    }
  }
  
  func fectchMyPostData(completion: @escaping ([CreatePostModel]) -> Void) {
    getMyPostData { result in
      var posts: [CreatePostModel] = []
      for (_, postDict) in result {
        if let postDict = postDict as? [String: Any], let post = self.parsePostData(postDict) {
          posts.append(post)
        }
      }
      completion(posts)
    }
  }
  
  // MARK: - postData to 구조체
  func parsePostData(_ data: [String: Any]) -> CreatePostModel? {
    guard let exerciseType = data["exerciseType"] as? [String],
          let gender = data["gender"] as? String,
          let info = data["info"] as? String,
          let postedDate = data["postedDate"] as? String,
          let time = data["time"] as? String,
          let userNickname = data["userNickname"] as? String,
          let userUid = data["userUid"] as? String,
          let location = data["location"] as? String
    else {
      return nil
    }
    
    return CreatePostModel(time: time,
                           workoutTypes: exerciseType,
                           gender: gender,
                           info: info,
                           userNickname: userNickname,
                           postedDate: postedDate,
                           userUid: userUid,
                           location: location )
  }
  
// MARK: - 유저 프로필 받아오기
  func getUserProfileImage(checkMyUid: Bool = true,
                           otherPersonUid: String = "",
                           completion: @escaping (Result<UIImage, Error>) -> Void) {
    getMyInfomation(checkMyUid: checkMyUid,
                    otherPersonUid: otherPersonUid) { result in
      guard let imageUrl = result.profileImageURL,
            let imageURL = URL(string: imageUrl) else {
        completion(.failure(MyPageError.imageURLNotFound))
        return
      }
      
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: 56, height: 56))
      
      KingfisherManager.shared.cache.removeImage(forKey: imageURL.absoluteString)
      
      KingfisherManager.shared.retrieveImage(with: imageURL,
                                             options: [.processor(processor)]) { result in
        switch result {
        case .success(let value):
          completion(.success(value.image))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
  
  func settingProfileImage(profile: UIImageView,
                           result: Result<UIImage, any Error>,
                           radious: CGFloat){
    DispatchQueue.main.async {
      switch result {
      case .success(let image):
        profile.image = image
        profile.layer.cornerRadius = radious
        profile.clipsToBounds = true
      case .failure(let error):
        print("Failed to load user profile image: \(error)")
      }
    }
  }
  
  
// MARK: - 게시글 삭제
  func deleteMyPost(postedDate: String,
                    info: String,
                    completion: @escaping () -> Void){
    let ref = ref.child("users").child(uid ?? "").child("posts").child(postedDate)
    ref.observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        return
      }
      
      let postedInfo = value["info"] as? String ?? ""
      if postedInfo == info {
        ref.removeValue { error, _ in
          if let error = error {
            print("Error removing data: \(error.localizedDescription)")
          } else {
            print("Data removed successfully.")
            self.updateCount(childType: "postCount", checkCraete: false)
            completion()
          }
        }
      }
    }
  }
}
