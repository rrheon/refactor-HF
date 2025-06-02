//
//  registerEmailViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/05.
//

import UIKit

import SnapKit
import Then

/// Healf-front-SignupFlow
/// Healf-front-InputUserInfoScreen
/// 회원가입정보 입력 화면
final class InputUserInfoViewController: UIViewController {
  
  let signupViewModel: SignupViewModel
  
  // 이메일 형식에 맞게, 비밀번호 형식에 맞게, 공백이 있으면 다음버튼 활성화 x
  private lazy var titleLabel = UILabel().then {
    $0.text = "사용하실 이메일 주소를 입력해주세요."
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 20)
  }
  
  private lazy var emailTextField = UITextField().then {
    $0.placeholder = "이메일을 입력해주세요."
    $0.font = .systemFont(ofSize: 15)
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.addBottomLine(withColor: .underlineGray, height: 1)
  }
  
  private lazy var passwordTextField = UITextField().then {
    $0.placeholder = "비밀번호를 다시 입력해주세요."
    $0.font = .systemFont(ofSize: 15)
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.addBottomLine(withColor: .underlineGray, height: 1)
  }


  private lazy var nextButton = UIHelper.shared.createHealfButton("다음", .unableGray, .white)
  
  var userInfo = SignupModel(email: "", password: "", nickname: "")
  
  
  init(_ viewModel: SignupViewModel) {
    self.signupViewModel = viewModel
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    
    setupLayout()
    makeUI()
    
    hideKeyboardWhenTappedAround()
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
  
  func focusoutAndShowPopup(desc: String){
    emailTextField.resignFirstResponder()
    
    if !passwordTextField.isHidden {
      passwordTextField.resignFirstResponder()
    }
    showPopupViewWithOneButton(desc)
  }
  
  func afterEnteredEmail() {
    guard let email = emailTextField.text,
          Utils.isValidEmail(testStr: email) else {
      focusoutAndShowPopup(desc: "이메일 주소를 정확히 입력해주세요.")
      return
    }
    
    signupViewModel.checkDuplication(checkType: "email", checkValue: email) { isDuplicatedEmail in
      if !isDuplicatedEmail {
        self.focusoutAndShowPopup(desc: "이미 사용중인 이메일입니다.")
      } else {
        self.userInfo.email = email
        
        self.titleLabel.text = "사용하실 비밀번호를 입력해주세요."
        
        self.emailTextField.text = nil
        self.emailTextField.placeholder = "비밀번호를 입력해주세요."
        
        self.emailTextField.isSecureTextEntry = true
        self.passwordTextField.isSecureTextEntry = true
        
        self.passwordTextField.isHidden = false
        
        self.nextButton.isEnabled = false
        self.nextButton.removeTarget(nil, action: nil, for: .allEvents)
        self.nextButton.addAction(UIAction { _ in
          self.afterEnterPassword()
        }, for: .touchUpInside)
      }
    }
  }
  
  // MARK: - 비밀번호 특수문자 등 유효성 확인
  func checkValidPassword(firstPassword: String,
                          secondPassword: String,
                          completion: @escaping (Bool) -> Void) {
    let specialCharacterRegEx = ".*[!&^%$#@()/]+.*"
    let textTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
    let result = textTest.evaluate(with: emailTextField.text)

    if emailTextField.text?.count ?? 0 < 10 || !result {
      focusoutAndShowPopup(desc: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함)")
      completion(false)
      return
    }
    
    // 다시 입력한 비밀번호가 일치한지 유효성 확인
    if firstPassword != secondPassword {
      focusoutAndShowPopup(desc: "비밀번호가 일치하지 않아요.")
      completion(false)
      return
    }
    completion(true)
  }
  
  // 첫번째 두번째 비밀번호가 같지 않을 경우, 비밀번호가 6자 이상
  func afterEnterPassword(){
    guard let password = passwordTextField.text,
          let checkPassword = emailTextField.text, checkPassword != "" else { return }
    
    checkValidPassword(firstPassword: password,
                       secondPassword: checkPassword) { checkPassword in
      if checkPassword {
        self.userInfo.password = password
        
        self.titleLabel.text = "사용하실 닉네임을 입력해주세요."
        self.emailTextField.isSecureTextEntry = false
        self.emailTextField.placeholder = "닉네임을 입력해주세요."
        self.emailTextField.text = nil
        
        self.passwordTextField.isHidden = true
        self.nextButton.isEnabled = false
        self.nextButton.removeTarget(nil, action: nil, for: .allEvents)
        self.nextButton.addAction(UIAction { _ in
          self.completeSignup()
        }, for: .touchUpInside)
      }
    }
  }
  
  // 닉네임 중복 확인필요
  func completeSignup(){
    guard let nickname = emailTextField.text else { return }
    signupViewModel.checkDuplication(checkType: "nickname",
                                          checkValue: nickname) { result in
      if !result {
        self.focusoutAndShowPopup(desc: "이미 사용중인 닉네임입니다.")
      } else {
        self.userInfo.nickname = nickname
        self.signupViewModel.registerUserData(email: self.userInfo.email,
                                              password: self.userInfo.password,
                                              nickname: self.userInfo.nickname) { result in
          if result {
            let completeVC = CompleteSignupViewController()
            self.navigationController?.pushViewController(completeVC, animated: true)
          }
        }
      }
    }
  }
}
