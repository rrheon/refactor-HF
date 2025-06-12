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
  case agreementScreenIsRequired  // 약관동의화면
  case inputUserInfoScreenIsRequired  // 유저정보입력화면
  case popupScreenIsRequired(type: PopupCase) // 팝업화면
  case completeSignupIsRequired   // 회원가입완료화면
  case safariScreenIsRequired(url: String) // 사파리화면
}

// MARK: Flow

/// 회원가입 Flow
class AuthFlow: Flow {
  
  private let stepper: AuthStepper
  
  var root: any RxFlow.Presentable {
    return rootViewController
  }
  
  lazy var rootViewController: UINavigationController = UINavigationController()
  
  init(){
    print(#fileID, #function, #line, "- ")
    self.stepper = AuthStepper()
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? AuthStep else { return .none }
    
    switch step {
    case .agreementScreenIsRequired:
      return setupAgreementScreen()
    case .inputUserInfoScreenIsRequired:
      return navToInputUserInfoScreen()
    case .completeSignupIsRequired:
      return navToCompletedSignupScreen()
    case .safariScreenIsRequired(let url):
      return presentSafariScreen(url: url)
    case .popupScreenIsRequired(let type):
      return presentPopupScreen(with: type)
    }
  }
  
  
  /// 이용약관 동의화면
  private func setupAgreementScreen() -> FlowContributors {
    let reactor: UserAgreementReactor = UserAgreementReactor()
    let vc = UserAgreeViewController(reactor: reactor, stepper: stepper)
    rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: stepper))
  }
  
  
  /// 사용자 정보 입력 화면
  private func navToInputUserInfoScreen() -> FlowContributors {
    let reactor: RegisterUserInfoReactor = AuthDIContainer.makeSignupWithEmailReactor()
    let vc = RegisterUserInfoViewController(reactor: reactor, stepper: stepper)
    rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: stepper))
  }
  
  /// 회원가입 완료 화면
  private func navToCompletedSignupScreen() -> FlowContributors {
    let vc = CompleteSignupViewController()
    rootViewController.pushViewController(vc, animated: true)
    return .none
  }
  
  /// 팝업 뷰 띄우기
  /// - Parameter popupCase: 팝업의 종류
  func presentPopupScreen(with popupCase: PopupCase) -> FlowContributors {
    let popupVC = PopupViewController(with: popupCase)
    
    if let topVC = topMostViewController(),
       let delegateVC = topVC as? PopupViewDelegate {
      popupVC.popupView.delegate = delegateVC
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.rootViewController.present(popupVC, animated: false)
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
    return AuthStep.agreementScreenIsRequired
  }
  
  func navigate(to step: AppStep) {
    self.steps.accept(step)
  }
}
