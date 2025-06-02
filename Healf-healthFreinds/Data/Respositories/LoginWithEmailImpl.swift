//
//  LoginWithEmailImpl.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/2/25.
//

import Foundation

import RxSwift

/// 이메일로 로그인 Impl
final class LoginWithEmailImpl: LoginWithEmailRepository {
  private let apiService: AuthNetwork
  
  init(apiService: AuthNetwork) {
    self.apiService = apiService
  }
  
  func loginWithEmail(email: String, password: String) -> Single<Bool> {
    return apiService.loginWithEmail(email: email, password: password)
  }
}
