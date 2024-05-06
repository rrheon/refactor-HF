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
  private lazy var titleLabel = uihelper.createSingleLineLabel("사용하실 이메일 주소를 입력해주세요.",
                                                               .black,
                                                               .boldSystemFont(ofSize: 20))
  private lazy var emailTextField = uihelper.createLoginTextField("이메일을 입력해주세요.")
  private lazy var passwordTextField = uihelper.createLoginTextField("비밀번호를 다시 입력해주세요.")
  private lazy var nextButton = uihelper.createHealfButton("다음", .unableGray, .white)
  
  var userInfo = SignupModel(email: "", password: "", nickname: "")
  
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
    navigationItem.rightBarButtonItem = .none
  }
  
  override func leftButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      titleLabel,
      emailTextField,
      passwordTextField,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(150)
      $0.leading.equalToSuperview().offset(30)
      $0.trailing.equalToSuperview().offset(-30)
    }
    
    emailTextField.addTarget(self,
                             action: #selector(textFieldDidBeginEditing(_:)),
                             for: .editingDidBegin)
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(100)
      $0.leading.trailing.equalTo(titleLabel)
    }
    
    passwordTextField.addTarget(self,
                                action: #selector(textFieldDidBeginEditing(_:)),
                                for: .editingDidBegin)
    passwordTextField.isHidden = true
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(70)
      $0.leading.trailing.equalTo(emailTextField)
    }
    
    nextButton.addAction(UIAction { _ in
      self.afterEnteredEmail()
    }, for: .touchUpInside)
    nextButton.isEnabled = false
    nextButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(150)
      $0.leading.equalToSuperview().offset(30)
      $0.trailing.equalToSuperview().offset(-30)
      $0.height.equalTo(48)
    }
  }
  
  // MARK: - Function
  @objc func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.addBottomLine(withColor: .mainBlue, height: 1)
    
    nextButton.isEnabled = true
    nextButton.backgroundColor = .mainBlue
  }
  
  func afterEnteredEmail(){
    guard let email = emailTextField.text else { return }
    userInfo.email = email
    
    titleLabel.text = "사용하실 비밀번호를 입력해주세요."
    
    emailTextField.text = nil
    emailTextField.placeholder = "비밀번호를 입력해주세요."
    passwordTextField.isHidden = false
    
    nextButton.isEnabled = false
    nextButton.removeTarget(nil, action: nil, for: .allEvents)
    nextButton.addAction(UIAction { _ in
      self.afterEnterPassword()
    }, for: .touchUpInside)
  }
  
  func afterEnterPassword(){
    guard let password = passwordTextField.text,
          let checkPassword = emailTextField.text, checkPassword != "" else { return }
    userInfo.password = password
    
    titleLabel.text = "사용하실 닉네임을 입력해주세요."
    emailTextField.placeholder = "닉네임을 입력해주세요."
    emailTextField.text = nil
    
    passwordTextField.isHidden = true
    nextButton.isEnabled = false
    nextButton.addAction(UIAction { _ in
      self.completeSignup()
    }, for: .touchUpInside)
  }
  
  func completeSignup(){
    guard let nickname = emailTextField.text else { return }
    userInfo.nickname = nickname
    signupViewModel.registerUserData(email: userInfo.email,
                                     password: userInfo.password,
                                     nickname: userInfo.nickname) {
      let completeVC = CompleSignupViewController()
      self.navigationController?.pushViewController(completeVC, animated: true)
    }
  }
}
