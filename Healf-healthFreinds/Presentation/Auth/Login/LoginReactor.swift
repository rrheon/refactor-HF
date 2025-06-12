//
//  LoginReactor.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/4/25.
//

import Foundation

import RxFlow
import RxSwift
import RxRelay
import ReactorKit

/// LoginReactor
/// - 사용자 로그인 리액터
final class LoginReactor: Reactor, Stepper {
  var steps: PublishRelay = PublishRelay<Step>()
  
  private let loginWithEmailUseCase: LoginWithEmailUseCase
  
  // 사용자와의 interaction
  // 로그인 버튼 탭, 회원가입 버튼 탭
  enum Action {
    case loginWithEmail(email: String?, password: String?)
    case signupBtnTapped
//    case loginWithKakao
//    case signupWithKakao
//    case loginWithApple
//    case signupWithApple
  }
  
  // Router 내에서 값 가공
  enum Mutation {
    case setLoginResult(Bool)
    case setError(String)
  }
  
  // 화면에 보여줄 정보
  struct State {
    var isLoginSuccess: Bool?
    var errorMessage: String?
  }

  var initialState: State

  init(loginWithEmailUseCase: LoginWithEmailUseCase) {
    self.loginWithEmailUseCase = loginWithEmailUseCase
    self.initialState = State()
  }
  
  // Action -> Mutation
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      
    case .loginWithEmail(let email, let password):
      guard let email = email,
            let password = password else {
        return .just(Mutation.setLoginResult(false))
      }
      
      return loginWithEmailUseCase.execute(email: email, password: password)
        .asObservable()
        .map { sucess in
          Mutation.setLoginResult(sucess)
        }
      
    case .signupBtnTapped:
      self.steps.accept(AppStep.signupFlowIsRequired)
      return .empty()
    }
  }
  
  // Mutation -> State
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      
    case .setLoginResult(let result):
      newState.isLoginSuccess = result
    case .setError(let message):
      newState.errorMessage = message
    }
    return newState
  }
}
