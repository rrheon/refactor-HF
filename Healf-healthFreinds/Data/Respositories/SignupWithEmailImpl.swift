//
//  SignupWithEmailImpl.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/3/25.
//

import Foundation

import RxSwift

/// 이메일로 회원가입 Impl
final class SignupWithEmailImpl: SignupWithEmailRepository {
  private let apiService: AuthNetwork
  
  init(apiService: AuthNetwork) {
    self.apiService = apiService
  }
  
  func signupWithEmail(userData: SignupUserEntity) -> Single<Bool>{
    return apiService.signupWithEmail(userData: userData)
  }
}
