//
//  MapFlow.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay

// MARK: 지도화면 Step

/// 지도화면 Step
enum MapStep: Step {
  case mapScreenIsRequired
}


// MARK: Flow

/// 지도화면 Flow
class MapFlow: Flow {
  var root: any RxFlow.Presentable {
    return rootViewController
  }
  
  var rootViewController: UINavigationController = UINavigationController ()
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? MapStep else { return .none }
    
    switch step {
    case .mapScreenIsRequired:
      return setupMapScreen()
    }
  }
  
  /// 지도화면 설정
  func setupMapScreen() -> FlowContributors {
    return .none
  }
}

// MARK: Stepper

/// 지도화면 Stepper
class MapStepper: Stepper {
  var steps: RxRelay.PublishRelay<any RxFlow.Step> = PublishRelay()
  
  var initialStep: any Step {
    return MapStep.mapScreenIsRequired
  }
  
  func navigate(to step: MapStep) {
    self.steps.accept(step)
  }
}




