//
//  Utils.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import Foundation

/// 사용자 정보 유효성 검사 메세지
/// - 이메일, 비밀번호, 닉네임
enum ValidationMessage {
  case invalidEmail
  case duplicateEmail
  case validEmail

  case invalidPassword
  case equalPassword
  case notEqualPassword
  case validPassword

  case duplicateNickname
  case isInvalidNickname
  case validNickname

  var message: String {
    switch self {
    case .invalidEmail: return "이메일 형식에 맞지 않습니다."
    case .duplicateEmail: return "이미 사용 중인 이메일입니다."
    case .validEmail: return ""
      
    case .invalidPassword: return "비밀번호 형식에 맞지 않습니다."
    case .notEqualPassword: return "비밀번호가 일치하지 않습니다."
    case .validPassword, .equalPassword: return ""
      
    case .duplicateNickname: return "이미 사용 중인 닉네임입니다."
    case .isInvalidNickname: return "닉네임 형식에 맞지 않습니다."
    case .validNickname: return ""
    }
  }
}

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
  static func checkValidPassword(password: String) -> Bool {
    let passwordRegEx = ".*[!&^%$#@()/]+.*"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluate(with: password)
  }
}
