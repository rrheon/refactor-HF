//
//  CreatePostViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/12/24.
//

import Foundation

import FirebaseFirestoreInternal
import FirebaseAuth
import FirebaseDatabase

final class CreatePostViewModel {
  static let shared = CreatePostViewModel()
 
  let db = Firestore.firestore()
  let uid = Auth.auth().currentUser?.uid
  let ref = Database.database().reference()
  
  func getCurrentDate() -> String {
      let currentDate = Date()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.string(from: currentDate)
  }

  func createPost(_ time: String,
                  _ workoutTyoes: [String],
                  _ gender: String,
                  _ info: String){
    guard let uid = uid else { return }
    let postId = ref.child("users").child(uid).child("posts").childByAutoId().key ?? ""
  
    let currentDate = getCurrentDate()
    
    loadUserPostsFromDatabase { re in
      if let nickname = re["nickname"] as? String {
        let userInfo = [
          "time": time,
          "exerciseType": workoutTyoes,
          "gender": gender,
          "info": info,
          "userNickname": nickname,
          "postedDate": currentDate,
          "userUid": uid
        ] as [String : Any]
        
        self.ref.child("users").child(self.uid ?? "").child("posts").child(postId).setValue(userInfo)
      }
    }
    
// 기존 db에 데이터 추가
//    ref.child("UserData").child(uid ?? "").child("testKey").setValue("testValue") { (error, ref) in
//        if let error = error {
//            print("Error adding new key: \(error.localizedDescription)")
//        } else {
//            print("New key added successfully!")
//        }
//    }
  }
  
  // 특정 유저의 게시물 불러오기
  func loadUserPostsFromDatabase(completion: @escaping ([String: Any]) -> Void) {
//    ref.child("users").child(uid ?? "").child("posts").observeSingleEvent(of: .value) { snapshot in
//      guard let value = snapshot.value as? [String: Any] else {
//        print("Failed to load user posts")
//        return
//      }
//      completion(value)
//    }
    
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
}
