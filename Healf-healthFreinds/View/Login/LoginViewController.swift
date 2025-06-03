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
  
  var userAuthReactor: LoginReactor?
  
  private var customView = LoginView()
  
  init(){
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
      .filter({ vc, _ in
        guard let email = vc.customView.emailTextField.text,
              let password = vc.customView.passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else { return false }
        return true
      })
      .subscribe(onNext: { vc, _ in
        UIApplication.shared.windows.first?.isUserInteractionEnabled = false
//        signupViewModel.loginToHealf(email: email, password: password)
        vc.loginToHealf()
      }, onCompleted: {
        self.customView.activityIndicator.stopAnimating()
        
        self.customView.emailTextField.text = nil
        self.customView.passwordTextField.text = nil
      })
      .disposed(by: disposeBag)
      
    customView.signupButton
      .rx.tap
      .withUnretained(self)
      .subscribe { (vc , _ ) in
        vc.userAuthReactor?.steps.accept(AppStep.signupFlowIsRequired)
      }
      .disposed(by: disposeBag)
  }
  
  override func loadView() {
    self.view = customView
  }
  
  // 로그인 중에 다른 버튼 터치 못하게
  func loginToHealf() {
    guard let email = customView.emailTextField.text?.description,
          let password = customView.passwordTextField.text?.description else { return }
    
//    userAuthReactor.loginToHealf(email: email, password: password)
  }
  
  func kakaoLoginButtonTapped(){
    waitingNetworking()
//    signupViewModel.kakaoLogin()
  }
  
  // MARK: - signupButtonTapped
  func signupButtonTapped(){
//    self.signupViewModel.steps.accept(AppStep.signupFlowIsRequired)
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

extension LoginViewController: LoginViewModelDelegate {
  
  // MARK: - LoginViewModelDelegate
  
  func loginDidSucceed(completion: @escaping () -> Void) {
//    let tapbarcontroller = TabBarController()
//    tapbarcontroller.modalPresentationStyle = .fullScreen
//    self.present(tapbarcontroller, animated: true, completion: nil)
//    UIApplication.shared.windows.first?.isUserInteractionEnabled = true
//
//    completion()
//    
  }
  
  func loginDidFail(with error: Error) {
    [
      customView.emailTextField,
      customView.passwordTextField
    ].forEach {
      $0.resignFirstResponder()
    }
    
    UIApplication.shared.windows.first?.isUserInteractionEnabled = true

    showPopupViewWithOnebuttonAndDisappearVC("아이디,비밀번호를 확인해주세요")
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
