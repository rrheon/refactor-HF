//
//  CreatePostViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/12/24.
//

import Foundation

import FirebaseDatabase

final class CreatePostViewModel: CommonViewModel {
  static let shared = CreatePostViewModel()
 
//  let db = Firestore.firestore()
  
  func createPost(_ time: String,
                  _ workoutTyoes: [String],
                  _ gender: String,
                  _ info: String,
                  _ location: String? = nil,
                  _ postedDate: String? = nil){
    guard let uid = uid else { return }
  
    let currentDate = postedDate == nil ? getCurrentDate() : postedDate
    
    loadUserNicknameFromDatabase { re in
      if let nickname = re["nickname"] as? String {
        let userInfo = [
          "time": time,
          "exerciseType": workoutTyoes,
          "gender": gender,
          "info": info,
          "userNickname": nickname,
          "postedDate": currentDate,
          "userUid": uid,
          "location": location
        ] as [String : Any]
        
        self.ref.child("users").child(self.uid ?? "").child("posts").child(currentDate ?? "").setValue(userInfo)
      }
      self.updateCount(childType: "postCount")
    }
  }
  
  // 특정 유저의 게시물 불러오기
  func loadUserNicknameFromDatabase(completion: @escaping ([String: Any]) -> Void) {
    ref.child("UserData").child(uid ?? "").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        print("Failed to load user posts")
        return
      }
      completion(value)
    }
  }
  
  // 모든 사용자의 모든 게시물 불러오기
  func loadAllPostsFromDatabase(completion: @escaping ([String: Any]) -> Void) {
    ref.child("users").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        print("Failed to load posts")
        return
      }
      completion(value)
    }
  }
  
  // MARK: - 유저정보 가져오기
  func getUserData(completion: @escaping ([String: Any]) -> Void){
    ref.child("UserData").child(uid ?? "").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        print("Failed to load user posts")
        return
      }
      completion(value)
    }
  }
  
  // MARK: - 게시글 수정
  func modifyMyPost(postedDate: String,
                    info: String,
                    completion: @escaping () -> Void){
    let ref = ref.child("users").child(uid ?? "").child("posts").child(postedDate)
    
    ref.observeSingleEvent(of: .value) { snapshot in
      guard var data = snapshot.value as? [String: Any] else { return }
      let postedInfo = data["info"] as? String ?? ""
      
      if postedInfo == info {
        var updatedData: [String: Any] = [:]
        
        updatedData["exerciseType"] as? [String]
        updatedData["gender"] as? String
        updatedData["info"] as? String
        updatedData["postedDate"] as? String
        updatedData["time"] as? String
        updatedData["userNickname"] as? String
      
      }
    }
  }
}

