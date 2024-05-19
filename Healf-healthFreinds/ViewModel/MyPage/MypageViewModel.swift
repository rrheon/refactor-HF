//
//  MypageViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/21/24.
//

import UIKit

import Kingfisher
import FirebaseDatabase
import RxSwift
import RxRelay

enum MyPageError: Error {
  case imageURLNotFound
}

protocol myPostedDataConfigurable {
  func configure(with data: CreatePostModel)
}

class MypageViewModel: CommonViewModel {
  let createViewModel = CreatePostViewModel.shared
  static let shared = MypageViewModel()
  
  lazy var myInfomationDatas = BehaviorRelay<UserModel?>(value: nil)
  
  override init() {
    super.init()
    updatesMyInfomation()
  }
  
  func updatesMyInfomation(){
    getMyInfomation()
      .subscribe(onNext: { [weak self] newData in
        self?.myInfomationDatas.accept(newData)
      })
      .disposed(by: disposeBag)
  }

  func getMyInfomation(checkMyUid: Bool = true,
                       otherPersonUid: String = "") -> Observable<UserModel>{
    return Observable.create { observer in
      let userUid = checkMyUid == true ? self.uid : otherPersonUid
      self.ref.child("UserDataInfo").child(userUid ?? "").observeSingleEvent(of: .value) { snapshot in
        guard let value = snapshot.value as? [String: Any] else { return }
        guard let userData = self.convertUserModel(data: value) else { return}
        observer.onNext(userData)
      }
      return Disposables.create()
    }
  }
  
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

  func fetchThisMonthData(checkMoveMonth: Bool = false,
                          year: String = "",
                          month: String = "",
                          completion: @escaping ([String: Any]?) -> Void) {
    var startDate = getStartDate()
    if checkMoveMonth {
      startDate[0] = year
      startDate[1] = month
    }
    // 년도 -> 월 -> 선택한 날짜의 데이터만 뽑기
    ref.child("History")
      .child(uid!)
      .child(startDate[0])
      .child(startDate[1]).observeSingleEvent(of: .value) { snapshot in
        if let value = snapshot.value as? [String: Any] {
          completion(value)
        } else {
          completion(nil)
        }
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
        if let postDict = postDict as? [String: Any], let post = self.parsePostInfo(postDict) {
          posts.append(post)
        }
      }
      completion(posts)
    }
  }
  
  // MARK: - 유저 프로필 받아오기
  func getUserProfileImage(width: Int = 56,
                           hegiht: Int = 56,
                           checkMyUid: Bool = true,
                           otherPersonUid: String = "",
                           completion: @escaping (Result<UIImage, Error>) -> Void) {
    getMyInfomation(checkMyUid: checkMyUid,
                    otherPersonUid: otherPersonUid) { result in
      guard let imageUrl = result.profileImageURL,
            let imageURL = URL(string: imageUrl) else {
        completion(.failure(MyPageError.imageURLNotFound))
        return
      }
      
      //원래 56 56
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: width, height: hegiht))
      
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
