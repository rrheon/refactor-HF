//
//  SignupViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/27/24.
//

import Foundation
import FirebaseAuth

class SignupViewModel: CommonViewModel{
  func registerUserData(email: String, password: String, nickname: String, completion: @escaping () -> Void){
    Auth.auth().createUser(withEmail: email,
                           password: password) { result, error in
      if let error = error {
        print("Error creating user:", error.localizedDescription)
        return
      }
      
      guard let uid = result?.user.uid else {
        print("Error: UID is nil.")
        return
      }

      let values = ["nickname": nickname,
                    "uid": uid,
                    "profileImage": "없음"]
      
      let valuesForUserData = ["nickname": nickname,
                               "uid": uid,
                               "togetherCount": 0,
                               "workoutCount": 0,
                               "postCount": 0,
                               "profileImage": "없음",
                               "location": "없음",
                               "introduce": "없읍"]
    
      
      // Replace "." with "_" in the UID to create a valid database path
      let sanitizedUID = uid.replacingOccurrences(of: ".", with: "_")
      
      self.ref.child("UserDataInfo").child(sanitizedUID).setValue(valuesForUserData) { (error, ref) in
        if let error = error {
          print("Error setting user data:", error.localizedDescription)
          return
        }
        
        print("User data successfully saved to database.")
      }
      
      self.ref.child("UserData").child(sanitizedUID).setValue(values) { (error, ref) in
        if let error = error {
          print("Error setting user data:", error.localizedDescription)
          return
        }
        completion()
        print("User data successfully saved to database.")
      }
    }
  }
}
