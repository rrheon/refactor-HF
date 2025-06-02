//
//  LoginWithEmailUseCase.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/2/25.
//

import Foundation

import RxSwift


/// 이메일로 로그인 UseCase
protocol LoginWithEmailUseCase {
  func execute(email: String, password: String) -> Single<Bool>
}


/// 이메일로 로그인 UseCaseImpl
final class LoginWithEmailUseCaseImpl: LoginWithEmailUseCase {
  private let repository: LoginWithEmailRepository

  init(repository: LoginWithEmailRepository) {
    self.repository = repository
  }
  
  
  /// 이메일로 로그인 실행
  /// - Parameters:
  ///   - email: 사용자의 이메일주소
  ///   - password: 사용자의 비밀번호
  func execute(email: String, password: String) -> Single<Bool> {
    return repository.loginWithEmail(email: email, password: password)
  }
  
}
