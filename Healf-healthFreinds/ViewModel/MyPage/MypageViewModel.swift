//
//  MypageViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/21/24.
//

import Foundation
import UIKit
import Kingfisher

enum MyPageError: Error {
  case imageURLNotFound
  // 다른 에러 유형 추가 가능
}

protocol myPostedDataConfigurable {
  func configure(with data: CreatePostModel)
}

class MypageViewModel: CommonViewModel {
  let createViewModel = CreatePostViewModel.shared
  static let shared = MypageViewModel()
  
  // 받아와야할 것 - 1.해당 월 전체(데이터 있으면 표시 없으면 냅두기), 2. 선택한 날짜의 데이터 뿌려주기
  func getMyInfomation(completion: @escaping(UserModel) -> Void){
    ref.child("UserDataInfo").child(uid ?? "").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else { return }
      guard let userData = self.convertUserModel(data: value) else { return}
      completion(userData)
    }
  }
  
  func fetchDailyData(_ selectedDay: String,
                      completion: @escaping ([String: Any]?) -> Void) {
    let startDate = getStartDate()
    // 년도 -> 월 -> 선택한 날짜의 데이터만 뽑기
    ref.child("History").child(uid!).child(startDate[0]).child(startDate[1]).child(selectedDay)
      .observeSingleEvent(of: .value) { snapshot in
        if let value = snapshot.value as? [String: Any] {
          completion(value)
        } else {
          completion(nil)
        }
      }
  }
  
  func getMyWorkoutHistory(completion: @escaping (([Int]) -> Void)){
    var monthlyWorkoutCheck: [Int] = []
    fetchThisMonthData { monthlyData in
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
  
  func getDailyHistory(_ selectedDay: String,
                       completion: @escaping (HistoryModel) -> Void) {
    fetchDailyData(selectedDay) { result in
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
  
  func parsePostData(_ data: [String: Any]) -> CreatePostModel? {
    guard let exerciseType = data["exerciseType"] as? [String],
          let gender = data["gender"] as? String,
          let info = data["info"] as? String,
          let postedDate = data["postedDate"] as? String,
          let time = data["time"] as? String,
          let userNickname = data["userNickname"] as? String,
          let userUid = data["userUid"] as? String
    else {
      return nil
    }
    
    return CreatePostModel(time: time, workoutTypes: exerciseType,
                           gender: gender,
                           info: info,
                           userNickname: userNickname, postedDate: postedDate,
                           userUid: userUid)
  }
  
  func getUserProfileImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
    getMyInfomation { result in
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
  
}
