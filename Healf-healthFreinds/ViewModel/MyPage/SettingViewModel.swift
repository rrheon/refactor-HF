//
//  SettingViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/9/24.
//

import Foundation

import Alamofire
import FirebaseAuth
import FirebaseDatabase

class SettingViewModel: CommonViewModel {
  static let shared = SettingViewModel()
  
  func revokeAppleToken(clientSecret: String, token: String, completionHandler: @escaping () -> Void) {
      let url = "https://appleid.apple.com/auth/revoke"
      let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
      let parameters: Parameters = [
          "client_id": "com.yongheon.Healf-healthFreinds",
          "client_secret": clientSecret,
          "token": token
      ]

      AF.request(url,
                 method: .post,
                 parameters: parameters,
                 headers: header)
      .validate(statusCode: 200..<300)
      .responseData { response in
          guard let statusCode = response.response?.statusCode else { return }
          if statusCode == 200 {
              print("애플 토큰 삭제 성공!")
              completionHandler()
          }
      }
  }
  // 누르면 바로 탈퇴가 아니라 알람 한번 보여주기
  // 로그아웃과 같이 login화면으로 나가야함, 데이터 삭제 필요
  
  func removeAccount() {
    // Delete other information from the database...
    // Sign out on FirebaseAuth
    [
      "UserData",
      "UserDataInfo",
      "users",
      "History"
    ].forEach {
      removeAccountData(path: $0)
    }
    
    getUserData(dataType: "location") { location in
      self.deleteUserData(forValue: location ?? "") { err in
        guard let error = err else {
          print("데이터를 찾을 수 없습니다.")
          return
        }
        print("삭제완료")
      }
    }
    
    let user = Auth.auth().currentUser
    
    user?.delete { error in
      if let error = error {
        print("사용자 삭제 실패:", error.localizedDescription)
      } else {
        print("사용자 삭제 성공")
      }
    }
  }
  
  func logout(completion: @escaping () -> Void) {
    do {
      // Firebase에서 로그아웃
      try Auth.auth().signOut()
      
      // 로그아웃 성공 후 맨 처음 뷰 컨트롤러로 이동
      
     completion()
    } catch {
      print("로그아웃 에러:", error.localizedDescription)
    }
  }
  // 본인 uid넣고 지우면 될듯
  // userlocation은 userdatainfo에서 위치를 받아서 userinfo 에 들어가서 해당 위치에 속하는 uid 찾아서 삭제
  // userdata, userdatainfo 는 uid찾아서 삭제
  // users도 uid로 삭제
  // history도 uid로 삭제
  func removeAccountData(path: String){
    self.ref.child("\(path)").child(uid ?? "").removeValue { err, _ in
      if let error = err {
        print("데이터 삭제 실패:", error)
      } else {
        print("데이터 삭제 성공")
      }
    }
  }
  
  func getUserData(dataType: String,
                       completion: @escaping (String?) -> Void) {
    ref.child("UserDataInfo").child(uid ?? "").observeSingleEvent(of: .value) { snapshot in
      guard let userData = snapshot.value as? [String: Any],
            let data = userData[dataType] as? String else {
        completion(nil) // 사용자 또는 위치 정보를 찾을 수 없을 때 nil 반환
        return
      }
      
      completion(data) // 사용자의 위치 정보를 반환하고 완료 핸들러 호출
    }
  }
  
  func deleteUserData(forValue value: String,
                      completion: @escaping (Error?) -> Void) {
    let query = ref.child("UserLocation").queryOrderedByValue().queryEqual(toValue: value)
    
    query.observeSingleEvent(of: .value) { snapshot in
      guard let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
        completion(nil) // 삭제할 데이터를 찾을 수 없을 때 nil 반환
        return
      }
      
      for data in dataSnapshot {
        data.ref.removeValue { error, _ in
          completion(error) // 삭제 작업이 완료되면 완료 핸들러 호출
        }
      }
    }
  }
  
  func settingMessageOption(_ messageOption: String){
    self.ref.child("UserDataInfo").child(self.uid ?? "").child("messageOption").setValue(messageOption)
  }
}
