//
//  AppFLow.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/20/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay
import SafariServices

// MARK: Step

/// App 전체 화면 이동을 관리하는 Step
enum AppStep: Step {
  
  /// 탭바 화면 타입
  enum SceneType {
    case home
    case search
    case map
    case chat
    case mypage
    
    /// 탭바 아이템
    var tabItem: UITabBarItem {
      switch self {
      case .home:
        return UITabBarItem(title: "홈", image: UIImage(named: "HomeImg"), tag: 0)
      case .search:
        return UITabBarItem(title: "탐색", image: UIImage(named: "SearchImg"), tag: 1)
      case .map:
        return UITabBarItem(title: "지도", image: UIImage(named: "MapImg"), tag: 2)
      case .chat:
        return UITabBarItem(title: "채팅", image: UIImage(named: "ChatImg"), tag: 3)
      case .mypage:
        return UITabBarItem(title: "마이페이지", image: UIImage(named: "MypageIconImg"), tag: 4)
      }
    }
  }
  
  
  /// 메인 탭 이동
  case mainTabIsRequired
  
  /// 로그인 화면
  case loginScreenIsRequired
  
  /// 회원가입 Flow
  case signupFlowIsRequired
  
  /// 팝업뷰 띄우기
  case popupScreenIsRequired(type: PopupCase)
  
  /// 사파리 화면 띄우기
  case safariScreenIsRequired(url: String)
}


// MARK: Flow

/// App 전체 Flow
class AppFlow: Flow {
  var root: any RxFlow.Presentable {
    return self.rootViewController
  }
  
  lazy var rootViewController: UINavigationController = UINavigationController()
  
  var tabBarController: UITabBarController = UITabBarController()
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? AppStep else { return .none }
    
    switch step {
    case .mainTabIsRequired:
      return setupMainTabBar()
    case .loginScreenIsRequired:
      return loginScreenIsRequired()
    case .signupFlowIsRequired:
      return signupScreenIsRequired()
    case .popupScreenIsRequired(let type):
      return presentPopupScreen(with: type)
    case .safariScreenIsRequired(let url):
      return presentSafariScreen(url: url)
    }
  }
  
  
  /// 탭바 설정
  func setupMainTabBar() -> FlowContributors {
    let homeFlow: HomeFlow = HomeFlow()
    let searchFlow: SearchFlow = SearchFlow()
    let mapFlow: MapFlow = MapFlow()
    let chatFlow: ChatFlow = ChatFlow()
    let mypageFlow: MypageFlow = MypageFlow()
    
    Flows.use(homeFlow, searchFlow, mapFlow, chatFlow, mypageFlow,
              when: .ready) { [unowned self] root1, root2, root3, root4, root5 in
    
      root1.tabBarItem = AppStep.SceneType.home.tabItem
      root2.tabBarItem = AppStep.SceneType.search.tabItem
      root3.tabBarItem = AppStep.SceneType.map.tabItem
      root4.tabBarItem = AppStep.SceneType.chat.tabItem
      root5.tabBarItem = AppStep.SceneType.mypage.tabItem
      
      tabBarController.viewControllers = [root1, root2, root3, root4, root5]
      tabBarController.selectedIndex = 0
      
      rootViewController.setViewControllers([tabBarController], animated: false)
      rootViewController.navigationBar.isHidden = true
    }
    
    return .multiple(flowContributors: [
      .contribute(withNextPresentable: homeFlow,
                  withNextStepper: OneStepper(withSingleStep: HomeStep.homeScreenIsRequired)),
      .contribute(withNextPresentable: searchFlow,
                  withNextStepper: OneStepper(withSingleStep: SearchStep.searchScreenIsRequired)),
      .contribute(withNextPresentable: mapFlow,
                  withNextStepper: OneStepper(withSingleStep: MapStep.mapScreenIsRequired)),
      .contribute(withNextPresentable: chatFlow,
                  withNextStepper: OneStepper(withSingleStep: ChatStep.chatListScreenIsRequired)),
      .contribute(withNextPresentable: mypageFlow,
                  withNextStepper: OneStepper(withSingleStep: MypageStep.myPageScreenIsRequired))

    ])
  }
  
  
  /// 로그인 화면 표시
  func loginScreenIsRequired() -> FlowContributors {
    let stepper: AppStepper = AppStepper()
    let reactor: LoginReactor = AuthDIContainer.makeLoginReactor()
    let vc = LoginViewController(reactor: reactor, stepper: stepper)
    rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: stepper))
  }
  
  
  /// 회원가입 Flow 띄우기
  func signupScreenIsRequired() -> FlowContributors {
    let signupFlow: AuthFlow = AuthFlow()
    Flows.use(signupFlow, when: .ready) { [unowned self] root in
      root.modalPresentationStyle = .fullScreen
      self.rootViewController.present(root, animated: true)
    }
    return .one(flowContributor: .contribute(withNextPresentable: signupFlow,
                                             withNextStepper: OneStepper(withSingleStep: AuthStep.agreementScreenIsRequired)))
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
  
  /// 사파리 화면 띄우기
  /// - Parameter url: 이동할 url
  func presentSafariScreen(url: String) -> FlowContributors {
    if let url = URL(string: url) {
      let urlView = SFSafariViewController(url: url)
      self.rootViewController.present(urlView, animated: true)
      return .none
    }
    return .none
  }
}


// MARK: Stepper

/// 전체 AppStepper
class AppStepper: Stepper {
  let steps: PublishRelay<Step> = PublishRelay()
  let disposBag = DisposeBag()

  var initialStep: any Step {
    return AppStep.loginScreenIsRequired
  }
  
  func navigate(to step: AppStep){
    self.steps.accept(step)
  }
  
  func readyToEmitSteps() {
    Observable.merge(
      /// 사파리 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToSafariScreen)
        .compactMap { $0.userInfo?["url"] as? String  }
        .map { AppStep.safariScreenIsRequired(url: $0) },
      
      /// popupView 띄우기
      NotificationCenter.default
        .rx
        .notification(.presentPopupScreen)
        .compactMap { notification in
          guard let popupCase = notification.userInfo?["popupCase"] as? PopupCase else {
            return nil
          }
          return AppStep.popupScreenIsRequired(type: popupCase)
        }
    )
    .bind(to: self.steps)
    .disposed(by: disposBag)
  }
}
