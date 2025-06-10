//
//  Utils.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import Foundation

/// 유효성 검사 class
final class Validators {
  
  /// 이메일 유효성 체크 함수
  /// - Parameter email: 체크할 이메일 값
  /// - Returns: 유효성 여부 반환
  static func checkValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }
  
  
  
  /// 비밀번호 유효성 체크 함수
  /// - Parameter password: 체크할 비밀번호 값
  /// - Returns: 유효성 여부 반환
  func checkValidPassword(password: String) -> Bool {
    let passwordRegEx = ".*[!&^%$#@()/]+.*"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluate(with: password)
  }
}
