//
//  MypageFlow.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay


// MARK: Step

/// 마이페이지 화면 Step
enum MypageStep: Step {
  case myPageScreenIsRequired       // 채팅방 리스트 화면
  case editProfileScreenIsRequired  // 채팅방 상새 화면
  case settingScreenIsRequired      // 설정 화면
}

// MARK: Flow

/// 마이페이지화면 Flow
class MypageFlow: Flow {
  var root: any RxFlow.Presentable {
    return rootViewController
  }
  
  var rootViewController: UINavigationController = UINavigationController ()

  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? MypageStep else { return .none }
    
    switch step {
    case .myPageScreenIsRequired:
      return setupMypageScreen()
    case .editProfileScreenIsRequired:
      return navToEditProfileScreen()
    case .settingScreenIsRequired:
      return navToSettingScreen()
    }
  }
  
  /// 마이페이 화면 셋팅
  func setupMypageScreen() -> FlowContributors {
    return .none
  }
  
  /// 프로필 편집 화면으로 이동
  func navToEditProfileScreen() -> FlowContributors {
    return .none
  }
  
  /// 앱 설정 화면으로 이동
  func navToSettingScreen() -> FlowContributors {
    return .none
  }
}

// MARK: Stepper

/// 마이페이지 Stepper
class MyPageStepper: Stepper {
  var steps: RxRelay.PublishRelay<any RxFlow.Step> = PublishRelay()
  
  var initialStep: any Step {
    return MypageStep.myPageScreenIsRequired
  }
  
  func navigate(to step: MypageStep) {
    self.steps.accept(step)
  }
  
}


