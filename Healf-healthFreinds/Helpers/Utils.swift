//
//  Utils.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import Foundation

/// Utils
final class Utils {

  
  /// 이메일 유효성 체크 함수
  /// - Parameter testStr: 체크할 이메일 값
  /// - Returns: 유효성 여부 반환
  static func isValidEmail(testStr: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
  }
}
