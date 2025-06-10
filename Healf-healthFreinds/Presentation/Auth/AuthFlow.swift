//
//  AuthFlow.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/27/25.
//

import UIKit
import SafariServices

import RxFlow
import RxSwift
import RxRelay

// MARK: Step


/// 회원가입 Step
enum AuthStep: Step {
  case agreementScreenIsReuqired  // 약관동의화면
  case inputUserInfoScreenIsReuqired  // 유저정보입력화면
  case completeSignupIsRequired   // 회원가입완료화면
  case safariScreenIsRequired(url: String) // 사파리화면
}

// MARK: Flow

/// 회원가입 Flow
class AuthFlow: Flow {
  
  let reactor: SignupReactor
  
  var root: any RxFlow.Presentable {
    return rootViewController
  }
  
  lazy var rootViewController: UINavigationController = UINavigationController()
  
  init(_ reactor: SignupReactor){
    print(#fileID, #function, #line, "- ")
    self.reactor = reactor
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? AuthStep else { return .none }
    
    switch step {
    case .agreementScreenIsReuqired:
      return setupAgreementScreen()
    case .inputUserInfoScreenIsReuqired:
      return navToInputUserInfoScreen()
    case .completeSignupIsRequired:
      return navToCompletedSignupScreen()
    case .safariScreenIsRequired(let url):
      return presentSafariScreen(url: url)
    }
  }
  
  
  /// 이용약관 동의화면
  private func setupAgreementScreen() -> FlowContributors {
    let vc = UserAgreeViewController(reactor)
    rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
  }
  
  
  /// 사용자 정보 입력 화면
  private func navToInputUserInfoScreen() -> FlowContributors {
    let vc = InputUserInfoViewController(reactor)
    rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
  }
  
  /// 회원가입 완료 화면
  private func navToCompletedSignupScreen() -> FlowContributors {
    let vc = CompleteSignupViewController()
    rootViewController.pushViewController(vc, animated: true)
    return .none
  }
  
  /// 사파리 화면 띄우기 - 개인정보처리방침, 서비스이용약관, 개발자연락
  /// - Parameter url: 이동할 url
  private func presentSafariScreen(url: String) -> FlowContributors {
    guard let url = URL(string: url) else { return .none }
    let urlView = SFSafariViewController(url: url)
    self.rootViewController.present(urlView, animated: true)
    return .none
  }
  
}


// MARK: Stepper

/// AuthStepper
class AuthStepper: Stepper {
  let steps: RxRelay.PublishRelay<any RxFlow.Step> = PublishRelay()
  
  var initialStep: Step {
    return AuthStep.agreementScreenIsReuqired
  }
  
  func navigate(to step: AppStep) {
    self.steps.accept(step)
  }
}
