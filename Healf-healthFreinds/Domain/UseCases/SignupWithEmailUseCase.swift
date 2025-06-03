//
//  SignupWithEmailUseCase.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/3/25.
//

import Foundation

import RxSwift

/// Email로 회원가입 UseCase
protocol SignupWithEmailUseCase {
  func execute(userData: SignupUserEntity) -> Single<Bool>
}


/// Email로 회원가입 UseCaseImpl
final class SignupWithEmailUseCaseImpl: SignupWithEmailUseCase {
  private let repository: SignupWithEmailRepository
  
  init(repository: SignupWithEmailRepository) {
    self.repository = repository
  }
  
  
  /// 이메일로 회원가입 실행
  /// - Parameter userData: 사용자의 정조
  func execute(userData: SignupUserEntity) -> Single<Bool> {
    return repository.signupWithEmail(userData: userData)
  }
}


