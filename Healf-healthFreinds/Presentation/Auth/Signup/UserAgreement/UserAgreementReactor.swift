//
//  UserAgreementReactor.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/12/25.
//


import Foundation

import RxSwift
import RxRelay
import ReactorKit


/// UserAgreementReactor
/// - 사용자 이용약관 리액터
final class UserAgreementReactor: Reactor {
  
  // 사용자와의 interaction
  enum Action {
    case toggleServiceAgree
    case togglePersonalAgree
    case servicePageTapped
    case personalInfoPageTapped
  }
  
  // Reactor 내에서 값 가공
  enum Mutation {
    case setServiceAgree(Bool)
    case setPersonalAgree(Bool)
    case setUrl(String)
  }
  
  // 화면에 보여줄 정보
  struct State {
    var isServiceAgreed: Bool = false
    var isPersonalAgreed: Bool = false
    var url: String?
    var isNextEnable: Bool { isServiceAgreed && isPersonalAgreed }
  }
  
  var initialState: State
  
  init() {
    self.initialState = State()
  }
  
  // Action -> Mutation
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .toggleServiceAgree:
      return .just(.setServiceAgree(!currentState.isServiceAgreed))
      
    case .togglePersonalAgree:
      return .just(.setPersonalAgree(!currentState.isPersonalAgreed))
      
    case .servicePageTapped:
      guard let url = DataLoaderFromPlist.loadURLs()?[UrlType.seriveInfo] else { return .empty() }
      return .just(.setUrl(url))
      
    case .personalInfoPageTapped:
      guard let url = DataLoaderFromPlist.loadURLs()?[UrlType.personInfo] else { return .empty() }
      return .just(.setUrl(url))
    
    }
  }
  
  // Mutation -> State
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setServiceAgree(let agreed):
      newState.isServiceAgreed = agreed
    case .setPersonalAgree(let agreed):
      newState.isPersonalAgreed = agreed
    case .setUrl(let url):
      newState.url = url
    }
    return newState
  }
}
