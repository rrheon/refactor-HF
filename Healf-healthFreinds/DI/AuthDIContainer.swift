//
//  AuthDIContainer.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/4/25.
//

import Foundation

/// 인증관련 DIContainer
final class AuthDIContainer {
  
  /// LoginReactor 주입
  class func makeLoginReactor() -> LoginReactor {
    return LoginReactor(loginWithEmailUseCase: makeLoginWithEmailUseCase())
  }

  private static func makeLoginWithEmailUseCase() -> LoginWithEmailUseCase {
    return LoginWithEmailUseCaseImpl(repository: makeLoginWithEmailRepository())
  }

  private static func makeLoginWithEmailRepository() -> LoginWithEmailRepository {
    return LoginWithEmailImpl(apiService: makeAuthNetwork())
  }
  
  private static func makeAuthNetwork() -> AuthNetwork {
    return AuthNetwork()
  }
  
  /// SignupReactor 주입
  class func makeSignupWithEmailReactor() -> SignupReactor {
    return SignupReactor(checkDuplicationUseCase: makeCheckDuplicationUseCase(),
                         signupWithEmailUseCase: makeSignupWithEmailUseCase())
  }
  
  private static func makeCheckDuplicationUseCase() -> CheckDuplicationUseCase {
    return CheckDuplicationUseCaseImpl(repository: makeCheckDuplicationRepository())
  }
  
  private static func makeCheckDuplicationRepository() -> CheckDuplicationRepository {
    return CheckDuplicationImpl(apiService: makeAuthNetwork())
  }
  
  private class func makeSignupWithEmailUseCase() -> SignupWithEmailUseCase {
    return SignupWithEmailUseCaseImpl(repository: makeSignupWithEmailRepository())
  }
  
  private static func makeSignupWithEmailRepository() -> SignupWithEmailRepository {
    return SignupWithEmailImpl(apiService: makeAuthNetwork())
  }
}

