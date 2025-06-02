//
//  SearchFlow.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay

// MARK: Step

/// 검색화면 Step
enum SearchStep: Step {
  case searchScreenIsRequired     // 검색화면
  case writePostScreenIsRequired  // 매칭 등록 화면
}


// MARK: Flow

/// 검색화면 Flow
class SearchFlow: Flow {
  var root: any RxFlow.Presentable {
    return rootViewController
  }
  
  var rootViewController: UINavigationController = UINavigationController()
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? SearchStep else { return .none }
    
    switch step {
    case .searchScreenIsRequired:
      return setupSearchScreen()
    case .writePostScreenIsRequired:
      return navToWritePostScreen()
    }
  }
  
  /// 검색화면 셋팅
  func setupSearchScreen() -> FlowContributors {
    return .none
  }
  
  /// 매칭 게시글 작성 화면으로 이동
  func navToWritePostScreen() -> FlowContributors {
    return .none
  }
  
}

// MARK: Stepper

/// 검색화면 Stepper
class SearchStepper: Stepper {
  var steps: RxRelay.PublishRelay<any RxFlow.Step> = PublishRelay()
  
  
  /// 초기 화면
  var initialStep: any Step {
    return SearchStep.searchScreenIsRequired
  }
  
  func navigate(to step: SearchStep) {
    self.steps.accept(step)
  }
}


