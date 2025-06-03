//
//  AuuthRepositories.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/2/25.
//

import Foundation

import RxSwift

// MARK: AuthInterfaceRepository (인증관련)


/// 중복체크 InterfaceRepository
protocol CheckDuplicationRepository {
  func checkDuplication(checkType: DuplicationCheckType, value: String) -> Single<Bool>
}

/// 이메일로 로그인 InterfaceRepository
protocol LoginWithEmailRepository {
  func loginWithEmail(email: String, password: String) -> Single<Bool>
}


/// 이메일로 회원가입 InterfaceRepository
protocol SignupWithEmailRepository {
  func signupWithEmail(userData: SignupUserEntity) -> Single<Bool>

}
