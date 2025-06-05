//
//  LoginView.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/17/25.
//

import UIKit

import SnapKit
import Then

// 로그인화면 View
final class LoginView: UIView {
  
  /// 메인 타이틀 라벨
  private lazy var titleLabel = UILabel().then {
    $0.text = "나만을 위한 헬스 친구 찾기,\nHeal F 🏋🏻"
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 16)
    $0.numberOfLines = 0
//    $0.setLineSpacing(spacing: 10)
  }
  
  /// 이메일 입력 TextField
  lazy var emailTextField = UITextField().then {
    $0.placeholder = "이메일"
    $0.font = .systemFont(ofSize: 15)
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.addBottomLine(withColor: .underlineGray, height: 1)
  }
  
  /// 비밀번호 입력 TextField
  lazy var passwordTextField = UITextField().then {
    $0.placeholder = "비밀번호"
    $0.font = .systemFont(ofSize: 15)
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.isSecureTextEntry = true
    $0.addBottomLine(withColor: .underlineGray, height: 1)
  }
  
  /// 이메일로 로그인버튼
  lazy var loginButton = UIHelper.shared.createHealfButton("로그인", .mainBlue, .white)
  
  /// 키키오로 로그인버튼
  lazy var kakaoLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "KakaoLoginImg"), for: .normal)
  }
  /// 애플로 로그인버튼
  lazy var appleLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "AppleLoginImg"), for: .normal)
  }
  
  /// 회원가입
  lazy var signupButton = UIButton().then {
    $0.setTitle("이메일로 회원가입", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.setUnderline(.gray)
  }
  
  lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - makeUI
  
  func makeUI(){
    
    self.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(150)
      $0.leading.equalToSuperview().offset(20)
    }
    
    self.addSubview(emailTextField)
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(100)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    self.addSubview(passwordTextField)
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(50)
      $0.leading.trailing.equalTo(emailTextField)
    }
    
    self.addSubview(loginButton)
    loginButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
      $0.leading.equalTo(emailTextField).offset(20)
      $0.trailing.equalTo(emailTextField).offset(-20)
      $0.height.equalTo(48)
    }
    
    self.addSubview(signupButton)
    signupButton.snp.makeConstraints {
      $0.top.equalTo(loginButton.snp.bottom).offset(50)
      $0.centerX.equalTo(loginButton)
    }
    
    self.addSubview(kakaoLoginButton)
    kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(signupButton.snp.bottom).offset(60)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(48)
    }
    
    self.addSubview(appleLoginButton)
    appleLoginButton.snp.makeConstraints {
      $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(48)
    }
  }
}
