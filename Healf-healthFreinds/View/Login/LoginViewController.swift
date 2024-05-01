//
//  ViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/01/11.
//

import UIKit

import SnapKit
import Then

import FirebaseAuth
import FirebaseFirestoreInternal
import KakaoSDKUser

final class LoginViewController: UIViewController, LoginViewModelDelegate {
  let signupViewModel = SignupViewModel()
  
  private lazy var titleLabel = UIHelper.shared.createMultipleLineLabel(
    "나만을 위한 헬스 친구 찾기,\nHeal F 🏋🏻",
    .black,
    .boldSystemFont(ofSize: 16),
    .left)
  
  private lazy var emailTextField = UIHelper.shared.createLoginTextField("아이디 또는 이메일")
  private lazy var passwordTextField = UIHelper.shared.createLoginTextField("비밀번호")
  
  private lazy var loginButton = UIHelper.shared.createHealfButton("로그인", .mainBlue, .white)
  
  private lazy var kakaoLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "KakaoLoginImg"), for: .normal)
    $0.addAction(UIAction { _ in
      self.kakaoLoginButtonTapped()
    }, for: .touchUpInside)
  }
  
  private lazy var naverLoginButton = UIHelper.shared.createHealfButton("네이버 로그인", .naverGreen, .white)
  
  private lazy var signupButton = UIButton().then {
    $0.setTitle("이메일로 회원가입", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.setUnderline(.gray)
    $0.addAction(UIAction { _ in
      self.signupButtonTapped()
    }, for: .touchUpInside)
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    signupViewModel.delegate = self
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      titleLabel,
      emailTextField,
      passwordTextField,
      loginButton,
      kakaoLoginButton,
      naverLoginButton,
      signupButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(150)
      $0.leading.equalToSuperview().offset(20)
    }
    
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(100)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(50)
      $0.leading.trailing.equalTo(emailTextField)
    }
    
    loginButton.addAction(UIAction { _ in
      self.loginToHealf()
    }, for: .touchUpInside)
    loginButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(48)
    }

    kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(loginButton.snp.bottom).offset(60)
      $0.leading.trailing.equalTo(loginButton)
      $0.height.equalTo(48)
    }
    
    naverLoginButton.snp.makeConstraints {
      $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(48)
    }
    
    signupButton.snp.makeConstraints {
      $0.top.equalTo(naverLoginButton.snp.bottom).offset(20)
      $0.centerX.equalTo(naverLoginButton)
    }
  }
  
  func loginToHealf() {
    guard let email = emailTextField.text?.description,
          let password = passwordTextField.text?.description else { return }
    signupViewModel.loginToHealf(email: email, password: password)
  }

  // MARK: - LoginViewModelDelegate
  func loginDidSucceed() {
    let tapbarcontroller = TabBarController()
    tapbarcontroller.modalPresentationStyle = .fullScreen
    self.present(tapbarcontroller, animated: true, completion: nil)
  }
  
  func loginDidFail(with error: Error) {
    // 로그인 실패 시 처리할 작업
  }
  
  func loginButtonTapped(){
    guard let email = emailTextField.text?.description,
          let password = passwordTextField.text?.description else { return }
    
    Auth.auth().signIn(withEmail: email,
                       password: password) { authResult, error in
      if authResult != nil {
        let tapbarcontroller = TabBarController()
        
        tapbarcontroller.modalPresentationStyle = .fullScreen
        
        self.present(tapbarcontroller, animated: true, completion: nil)
      } else {
        print("로그인 실패")
        print(error.debugDescription)
      }
    }
  }
  
  func kakaoLoginButtonTapped(){
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
        if let error = error {
          print(error)
        }
        else {
          print("loginWithKakaoTalk() success.")
          
          //do something
          self.signupViewModel.kakaoAuthSignIn()
          _ = oauthToken
        }
      }
    }
  }
  
  // MARK: - signupButtonTapped
  func signupButtonTapped(){
    let registerEmailVC = SignuplViewController()
    let navigationVC = UINavigationController(rootViewController: registerEmailVC)
    navigationVC.modalPresentationStyle = .fullScreen
    self.present(navigationVC, animated: true, completion: nil)
  }
}

