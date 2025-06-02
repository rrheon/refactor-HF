//
//  ChatFlow.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay


// MARK: Step

/// 채팅 화면 Step
enum ChatStep: Step {
  case chatListScreenIsRequired         // 채팅방 리스트 화면
  case chatDetailScreenIsRequired       // 채팅방 상새 화면
}

// MARK: Flow

/// 채팅화면 Flow
class ChatFlow: Flow {
  var root: any RxFlow.Presentable {
    return rootViewController
  }
  
  var rootViewController: UINavigationController = UINavigationController ()

  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? ChatStep else { return .none }
    
    switch step {
    case .chatListScreenIsRequired:
      return setupChatListScreen()
    case .chatDetailScreenIsRequired:
      return navToChatDetailScreen()
    }
  }
  
  /// 채팅방리스트 화면 셋팅
  func setupChatListScreen() -> FlowContributors {
    return .none
  }
  
  /// 채팅방 상세 화면으로 이동
  func navToChatDetailScreen() -> FlowContributors {
    return .none
  }
}

// MARK: Stepper

/// 채팅화면 Stepper
class ChatStepper: Stepper {
  var steps: RxRelay.PublishRelay<any RxFlow.Step> = PublishRelay()
  
  var initialStep: any Step {
    return ChatStep.chatListScreenIsRequired
  }
  
  func navigate(to step: ChatStep) {
    self.steps.accept(step)
  }
  
}


