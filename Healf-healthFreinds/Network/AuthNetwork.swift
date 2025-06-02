//
//  AuthNetwork.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/2/25.
//

import Foundation

import RxSwift
import FirebaseDatabase
import FirebaseAuth


/// 인증관련 네트워크
final class AuthNetwork {

  /// 중복 체크 함수 ( 이메일, 닉네임 )
  /// - Parameters:
  ///   - checkType: nickname, email
  ///   - checkValue: 중복여부를 체크할 값
  func checkDuplication(checkType: DuplicationCheckType,
                              checkValue: String) -> Single<Bool> {
    return Single.create { single in
      let ref = Database.database().reference()

      ref.child("UserDataInfo").observeSingleEvent(of: .value) { snapshot in
        guard let value = snapshot.value as? [String: [String: Any]] else {
          single(.success(false))
          return
        }
        
        let checkType = checkType.rawValue
        let datas = value.compactMap { $0.value[checkType] as? String }
        let isDuplicated = datas.contains(checkValue)
        single(.success(isDuplicated))
      }
      
      return Disposables.create()

    }
  }
  
  /// 이메일로 로그인 함수
  /// - Parameters:
  ///   - email: 사용자의 이메일
  ///   - password: 사용자의 비밀번호
  func loginWithEmail(email: String, password: String) -> Single<Bool> {
    return Single.create { single in
      Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        // 로그인 성공 시
        guard let _error = error else {
          single(.success(true))
          return
#warning("파이어베이스 토큰 관련 메소드 따로 빼서 추후 구현")
//          let uid = Auth.auth().currentUser?.uid
//          Messaging.messaging().token { token, error in
//            if let error = error {
//              print("Error fetching FCM registration token: \(error)")
//            } else if let token = token {
//              print("FCM registration token: \(token)")
//              self?.ref.child("UserDataInfo").child(uid ?? "").updateChildValues(["pushToken": token])
//            }
//          }
        }
        
        // 로그인 실패 시
        
        single(.success(false))
      }
      return Disposables.create()
    }
  }
}

