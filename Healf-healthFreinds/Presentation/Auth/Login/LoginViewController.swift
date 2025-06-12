//
//  ViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/01/11.
//

import UIKit

import SnapKit
import Then
import AuthenticationServices
import FirebaseAuth
import RxSwift
import RxCocoa
import RxRelay

/// Healf-front-AppFlow
/// Healf-front-LoginScreen
/// 로그인화면
final class LoginViewController: UIViewController {
  fileprivate var currentNonce: String?
  
  var disposeBag: DisposeBag = DisposeBag()
  
  private let stepper: AppStepper
  private let reactor: LoginReactor
  
  private var customView = LoginView()
  
  init(reactor: LoginReactor, stepper: AppStepper){
    self.stepper = stepper
    self.reactor = reactor

    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    customView.loginButton
      .rx.tap
      .withUnretained(self)
      .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
      .compactMap { vc, _ in
        guard let email = vc.customView.emailTextField.text,
              let password = vc.customView.passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else { return nil }
        return LoginReactor.Action.loginWithEmail(email: email, password: password)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)


    customView.signupButton
      .rx.tap
      .subscribe(onNext: { _ in
        self.stepper.steps.accept(AppStep.signupFlowIsRequired)
      })
      .disposed(by: disposeBag)

    reactor.state
      .compactMap(\.isLoginSuccess)
      .subscribe(onNext: { isLoginSuccess in
        print("login sucess - \(isLoginSuccess)")
        let nextStep: AppStep = isLoginSuccess ? .mainTabIsRequired : .popupScreenIsRequired(type: .failToLogin)
        self.stepper.steps.accept(nextStep)
      })
      .disposed(by: disposeBag)
  }
  
  override func loadView() {
    self.view = customView
  }

  
  func kakaoLoginButtonTapped(){
    waitingNetworking()
//    signupViewModel.kakaoLogin()
  }

  
  // 처음에 계정등록절차를 밟으면 될드
  func appleLogin(){
    let nonce = String().randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = String().sha256(nonce)
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  
  // MARK: - 네트워킹 기다릴 때
  func waitingNetworking(){
    UIApplication.shared.windows.first?.isUserInteractionEnabled = false

    view.addSubview(customView.activityIndicator)
    
    customView.activityIndicator.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    customView.activityIndicator.startAnimating()
  }
}


extension LoginViewController: ASAuthorizationControllerDelegate,
                               ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
  
  func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithAuthorization authorization: ASAuthorization) {
//    signupViewModel.appleLogin(authorization: authorization, currentNonce: currentNonce) {
//      self.loginDidSucceed {
//        UIApplication.shared.windows.first?.isUserInteractionEnabled = true
//
//        self.signupViewModel.searchUID()
//      }
//    }
  }
  
  func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithError error: Error) {
    // 로그인 실패(유저의 취소도 포함)
    print("Sign in with Apple errored: \(error)")
  }
}

// MARK: 팝업뷰 Delegate

extension LoginViewController: PopupViewDelegate {}
