//
//  registerEmailViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/05.
//

import UIKit

import SnapKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

final class SignuplViewController: NaviHelper {
  
  let signupViewModel = SignupViewModel()
  
  // 이메일 형식에 맞게, 비밀번호 형식에 맞게, 공백이 있으면 다음버튼 활성화 x
  private lazy var emailTextField = UIHelper.shared.createLoginTextField("이메일을 입력해주세요.")
  private lazy var passwordTextField = UIHelper.shared.createLoginTextField("비밀번호를 입력해주세요.")
  private lazy var nicknameTextField = UIHelper.shared.createLoginTextField("닉네임을 입력해주세요.")
  private lazy var nextButton = UIHelper.shared.createHealfButton("다음", .unableGray, .white)
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    settingNavigationTitle(title: "사용하실 계정의 정보를 입력해주세요")
    navigationItem.rightBarButtonItem = .none
  }
  
  override func leftButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      emailTextField,
      passwordTextField,
      nicknameTextField,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    emailTextField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(150)
      $0.leading.equalToSuperview().offset(30)
      $0.trailing.equalToSuperview().offset(-30)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(emailTextField)
    }
    
    nicknameTextField.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(emailTextField)
    }
    
    nextButton.addAction(UIAction { _ in
      self.completeSignup()
    }, for: .touchUpInside)
    nextButton.snp.makeConstraints {
      $0.top.equalTo(nicknameTextField.snp.bottom).offset(100)
      $0.leading.equalToSuperview().offset(30)
      $0.trailing.equalToSuperview().offset(-30)
      $0.height.equalTo(48)
    }
  }
  
  func completeSignup(){
    guard let email = emailTextField.text,
          let password = passwordTextField.text,
    let nickname = nicknameTextField.text  else { return }
    
    print("이메일: \(email)")
    print("비밀번호: \(password)")
    signupViewModel.registerUserData(email: email, password: password, nickname: nickname) {
      let completeVC = CompleSignupViewController()
      self.navigationController?.pushViewController(completeVC, animated: true)
    }
  }
}
