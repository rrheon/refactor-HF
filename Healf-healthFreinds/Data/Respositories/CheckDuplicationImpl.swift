//
//  CheckDuplicationImpl.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/2/25.
//

import Foundation

import RxSwift


/// 중복체크 Impl
final class CheckDuplicationImpl: CheckDuplicationRepository {
  private let apiService: AuthNetwork
  
  init(apiService: AuthNetwork) {
    self.apiService = apiService
  }
  
  func checkDuplication(checkType: DuplicationCheckType, value: String) -> Single<Bool> {
    return apiService.checkDuplication(checkType: checkType, checkValue: value)
  }
}
