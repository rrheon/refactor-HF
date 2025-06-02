//
//  CheckDuplicationUseCase.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/2/25.
//

import Foundation

import RxSwift

/// 중복값 체크 enum
enum DuplicationCheckType: String {
  case email = "email"
  case nickname = "nickname"
}


/// 중복체크 UseCase
protocol CheckDuplicationUseCase {
  func execute(checkType: DuplicationCheckType, value: String) -> Single<Bool>
}


/// 중복체크 UseCaseImpl
final class CheckDuplicationUseCaseImpl: CheckDuplicationUseCase {
  private let repository: CheckDuplicationRepository
  
  init(repository: CheckDuplicationRepository) {
    self.repository = repository
  }
  
  /// 중복체크 실행
  /// - Parameters:
  ///   - checkType: 중복체크 타입(email / nickname)
  ///   - value: 중복체크 할 값
  func execute(checkType: DuplicationCheckType, value: String) -> Single<Bool> {
    return repository.checkDuplication(checkType: checkType, value: value)
  }
}
