//
//  SignupReactor.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/3/25.
//

import Foundation

import RxSwift
import RxRelay
import ReactorKit


/// RegisterUserInfoReactor
/// - 사용자 정보 등록 리액터
final class RegisterUserInfoReactor: Reactor {
    
  private let checkDuplicationUseCase: CheckDuplicationUseCase
  private let signupWithEmailUseCase: SignupWithEmailUseCase
  
  // 사용자와의 interaction
  enum Action {
    case userEmail(String)
    case userPassword(String)
    case userNickname(String)
    case checkEqualPassowrd(String)
    case signupWithEmail
  }
  
  // Reactor 내에서 값 가공
  enum Mutation {
    case setUserEmail(String)
    case setUserPassword(String)
    case setUserNickname(String)
    case setValidtaion(ValidationMessage)
    case setEqaulPassword(Bool)
    case setSignupResult(Bool)
    case setError(String)
  }
  
  // 화면에 보여줄 정보
  struct State {
    var userEmail: String?
    var userPassword: String?
    var userNickname: String?
    var isEqualPassword: Bool = false
    
    var validationMessagee: ValidationMessage?
    var isSignupBtnEnable: Bool {
      guard let email = userEmail, !email.isEmpty,
            let nickname = userNickname, !nickname.isEmpty,
            let password = userPassword, !password.isEmpty,
            isEqualPassword else {
        return false
      }
      return true
    }
    
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
    // 사용자의 이메일이 들어왔을 경우
    case .userEmail(let email):
      let isValid = Validators.checkValidEmail(email: email)
      // 이메일 형식 검사
      let message: ValidationMessage = isValid ? .validEmail : .invalidEmail
      
      // 유효하지 않은경우 여기서 종료
      guard isValid else { return .just(Mutation.setValidtaion(message)) }
      
      // 유효한 경우 이메일 중복검사
      return checkDuplicationUseCase.execute(checkType: .email, value: email)
        .asObservable()
        .map { isDuplicate -> ValidationMessage in
          return isDuplicate ? .duplicateEmail : .validEmail
        }
        .flatMap({ message in
          let email = (message == .validEmail) ? email : ""
          
          return Observable.concat(.just(Mutation.setValidtaion(message)),
                                   .just(Mutation.setUserEmail(email)))
        })
      
      // 사용자의 비밀번호
    case .userPassword(let password):
      let isValid = Validators.checkValidPassword(password: password)
      let message: ValidationMessage = isValid ? .validPassword : .invalidPassword
      
      let password = (message == .validPassword) ? password : ""
      
      return .concat(.just(Mutation.setValidtaion(message)),
                     .just(Mutation.setUserPassword(password)))
      
      // 사용자의 닉네임
    case .userNickname(let nickname):
      guard nickname.count >= 2 else {
        return .just(Mutation.setValidtaion(.isInvalidNickname))
      }
      
      return checkDuplicationUseCase.execute(checkType: .nickname, value: nickname)
        .asObservable()
        .map { isDuplicate -> ValidationMessage in
          return isDuplicate ? .duplicateNickname : .validNickname
        }
        .flatMap { message in
          let nickname = (message == .validNickname) ? nickname : ""
          
          return Observable.concat(.just(Mutation.setValidtaion(message)),
                                   .just(Mutation.setUserNickname(nickname)))
        }
      
      // 비밀번호 일치 여부
    case .checkEqualPassowrd(let checkPassword):
      let isEqualPassword = checkPassword == currentState.userPassword
      let message: ValidationMessage = isEqualPassword ? .equalPassword: .notEqualPassword
      return Observable.concat(.just(Mutation.setValidtaion(message)),
                               .just(Mutation.setEqaulPassword(isEqualPassword)))
      
    // 회원가입
    case .signupWithEmail:
      guard let email = currentState.userEmail, !email.isEmpty,
            let password = currentState.userPassword, !password.isEmpty,
            let nickname = currentState.userNickname, !nickname.isEmpty else {
        return .just(Mutation.setSignupResult(false))
      }
      
      let value: SignupUserEntity = SignupUserEntity(email: email,
                                                     password: password,
                                                     nickname: nickname)
      
      // 성공 시 화면전환 , 실패 시 팝업 띄우
      return signupWithEmailUseCase.execute(userData: value)
        .asObservable()
        .map { Mutation.setSignupResult($0) }
        .catch { .just(.setError($0.localizedDescription)) }
    }
  }
  
  // Mutation -> State
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setValidtaion(let result):
      newState.validationMessagee = result
    case .setSignupResult(let result):
      newState.isSignupSucess = result
    case .setError(let err):
      newState.errorMessage = err
    case .setUserEmail(let email):
      newState.userEmail = email
    case .setUserPassword(let password):
      newState.userPassword = password
    case .setUserNickname(let nickname):
      newState.userNickname = nickname
    case .setEqaulPassword(let result):
      newState.isEqualPassword = result
    }
    return newState
  }
}
