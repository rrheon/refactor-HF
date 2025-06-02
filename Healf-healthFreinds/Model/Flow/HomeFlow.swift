//
//  HomeFlow.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay

// MARK: Step

// Home화면 Step
enum HomeStep: Step {
  case homeScreenIsRequired     // 홈화면
  case recordScreenIsRequired   // 운동기록 화면
  case selectFreindIsRequired   // 함께한 친구 선택 화면
}

// MARK: Flow

// Home Flow
class HomeFlow: Flow {
  let viewModel: HomeViewModel
  
  var root: any RxFlow.Presentable {
    return rootViewController
  }
  
  let rootViewController: UINavigationController = UINavigationController()
  
  init(){
    self.viewModel = HomeViewModel.shared
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? HomeStep else { return .none }
    switch step {
    case .homeScreenIsRequired:
      return setupHomeScreen()
    case .recordScreenIsRequired:
      return navToRecordScreen()
    case .selectFreindIsRequired:
      return navToSelectFreindScreen()
    }
  }
  
  /// 홈화면 셋팅
  func setupHomeScreen() -> FlowContributors {
    let vc = HomeViewController()
    self.rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 운동기록화면으로 이동
  func navToRecordScreen() -> FlowContributors {
    return .none
  }
  
  /// 함께한 친구 선택하기 화면으로 이동
  func navToSelectFreindScreen() -> FlowContributors {
    return .none
  }
}

// MARK: stepper

class HomeStepper: Stepper {
  var steps: RxRelay.PublishRelay<any RxFlow.Step> = PublishRelay()
  
  /// 초기 화면
  var initialStep: any Step {
    return HomeStep.homeScreenIsRequired
  }
  
  func navigate(to step: HomeStep) {
    self.steps.accept(step)
  }
}

