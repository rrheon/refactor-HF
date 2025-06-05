//
//  SignupReactor.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/3/25.
//

import Foundation

import RxFlow
import RxSwift
import RxRelay
import ReactorKit


/// SignupReactor
/// - 사용자 회원가입 리액터
final class SignupReactor: Reactor, Stepper {

  var steps: PublishRelay = PublishRelay<Step>()
  
  private let checkDuplicationUseCase: CheckDuplicationUseCase
  private let signupWithEmailUseCase: SignupWithEmailUseCase

  // 사용자와의 interaction
  enum Action {
    case userEmail(text: String)
    case userPassword(text: String)
    case userNickname(text: String)
    case checkDuplication(checkType: DuplicationCheckType, value: String)
    case signupWithEmail
  }
  
  // Reactor 내에서 값 가공
  enum Mutation {
    case setEmail(String)
    case setPassword(String)
    case setNickname(String)
    case setDuplicationResult(Bool)
    case setSignupResult(Bool)
    case setError(String)
  }
  
  // 화면에 보여줄 정보
  struct State {
    var userEmail: String?
    var userPassword: String?
    var userNickname: String?
    var isDuplicate: Bool?
    var isSignupSucess: Bool?
    var errorMessage: String?
  }
  
  var initialState: State
  
  init(checkDuplicationUseCase: CheckDuplicationUseCase,
       signupWithEmailUseCase: SignupWithEmailUseCase) {
    self.checkDuplicationUseCase = checkDuplicationUseCase
    self.signupWithEmailUseCase = signupWithEmailUseCase
    self.initialState = State()
  }
  
  // Action -> Mutation
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkDuplication(let checkType, let value):
      return checkDuplicationUseCase.execute(checkType: checkType , value: value)
        .asObservable()
        .map { Mutation.setDuplicationResult($0) }
        .catch { .just(.setError($0.localizedDescription)) }
      
    case .signupWithEmail:
      guard let email = currentState.userEmail,
            let password = currentState.userPassword,
            let nickname = currentState.userNickname else {
        return .just(Mutation.setSignupResult(false))
      }
      
      let value: SignupUserEntity = SignupUserEntity(email: email, password: password, nickname: nickname)
      
      return signupWithEmailUseCase.execute(userData: value)
        .asObservable()
        .map { Mutation.setSignupResult($0) }
        .catch { .just(.setError($0.localizedDescription)) }
      
    case .userEmail(let text):
      return .just(.setEmail(text))
      
    case .userPassword(let text):
      return .just(.setPassword(text))
      
    case .userNickname(let text):
      return .just(.setNickname(text))
    }
  }
  
  // Mutation -> State
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      
    case .setEmail(let text):
      newState.userEmail = text
    case .setPassword(let text):
      newState.userPassword = text
    case .setNickname(let text):
      newState.userNickname = text
    case .setDuplicationResult(let result):
      newState.isDuplicate = result
    case .setSignupResult(let result):
      newState.isSignupSucess = result
    case .setError(let err):
      newState.errorMessage = err
    }
    return state
  }
}
