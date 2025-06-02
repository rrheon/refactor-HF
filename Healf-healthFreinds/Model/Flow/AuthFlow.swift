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
enum AuthStep: Step{
  case agreementScreenIsReuqired  // 약관동의화면
  case inputUserInfoScreenIsReuqired  // 유저정보입력화면
  case completeSignupIsRequired   // 회원가입완료화면
}

// MARK: Flow

/// 회원가입 Flow
class AuthFlow: Flow {
  
  let viewModel: SignupViewModel
  
  var root: any RxFlow.Presentable {
    return rootViewController
  }
  
  lazy var rootViewController: UINavigationController = UINavigationController()
  
  init(_ viewModel: SignupViewModel){
    print(#fileID, #function, #line, "- ")
    self.viewModel = viewModel
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? AuthStep else { return .none }
    
    switch step {
    case .agreementScreenIsReuqired:
      return setupAgreementScreen()
    case .inputUserInfoScreenIsReuqired:
      return navToInputUserInfoScreen()
    case .completeSignupIsRequired:
      return .none
    }
  }
  
  
  /// 이용약관 동의화면
  func setupAgreementScreen() -> FlowContributors {
    let vc = UserAgreeViewController()
    rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 사용자 정보 입력 화면
  func navToInputUserInfoScreen() -> FlowContributors {
    let vc = InputUserInfoViewController(viewModel)
    rootViewController.pushViewController(vc, animated: true)
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
