//
//  registerEmailViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/05.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxFlow

/// Healf-front-SignupFlow
/// Healf-front-InputUserInfoScreen
/// 회원가입정보 입력 화면
final class RegisterUserInfoViewController: UIViewController{

  private let stepper: AuthStepper
  private let reactor: RegisterUserInfoReactor
  
  let disposeBag: DisposeBag = DisposeBag()
  
  private lazy var containerStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
    $0.spacing = 25
  }
  
  private lazy var titleLabel = UILabel().then {
    $0.text = LabelTitle.inputEmail
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 20)
  }
  
  
  /// 이메일 입력 TexField
  private lazy var emailTextField = AuthTextField(with: TextFieldPlaceholder.inputEmail)

  /// 비밀번호 입력 TexField
  private lazy var passwordTextField = AuthTextField(with: TextFieldPlaceholder.inputPassword)
  /// 비밀번호 재입력 TexField
  private lazy var checkPasswordTextField = AuthTextField(with: TextFieldPlaceholder.inputCheckPassword)
  /// 닉네임 입력 TexField
  private lazy var nicknameTextField = AuthTextField(with: TextFieldPlaceholder.inputNickname)
  
  private lazy var signupButton = UIHelper.shared.createHealfButton(BtnTitle.next, .unableGray, .white)

  init(reactor: RegisterUserInfoReactor, stepper: AuthStepper) {
    self.reactor = reactor
    self.stepper = stepper
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    makeUI()
    
    hideKeyboardWhenTappedAround()
    
    leftButtonSetting()
    
    bind(reactor: reactor)
    
    passwordTextField.setSecureTextField()
    checkPasswordTextField.setSecureTextField()
  }

  
  // MARK: - makeUI
  
  
  func makeUI(){
    [
      titleLabel,
      emailTextField,
      passwordTextField,
      checkPasswordTextField,
      nicknameTextField
    ].forEach {
      containerStackView.addArrangedSubview($0)
      
      $0.snp.makeConstraints {
        $0.height.equalTo(55)
      }
    }
    
    view.addSubview(containerStackView)
    containerStackView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      $0.leading.trailing.equalToSuperview().inset(30)
    }
    
    view.addSubview(signupButton)
    signupButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
      $0.leading.trailing.equalTo(containerStackView)
      $0.height.equalTo(48)
    }
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
  
  private func bind(reactor: RegisterUserInfoReactor){
    
    // 이메일
    emailTextField.textField
      .rx.value.orEmpty
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .filter { !$0.isEmpty }
      .map { RegisterUserInfoReactor.Action.userEmail($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 비밀번호
    passwordTextField.textField
      .rx.value.orEmpty
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .filter { !$0.isEmpty }
      .map { RegisterUserInfoReactor.Action.userPassword($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 비밀번호 확인
    checkPasswordTextField.textField
      .rx.value.orEmpty
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .filter { !$0.isEmpty }
      .map { RegisterUserInfoReactor.Action.checkEqualPassowrd($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 닉네임
    nicknameTextField.textField
      .rx.value.orEmpty
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .filter { !$0.isEmpty }
      .map { RegisterUserInfoReactor.Action.userNickname($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 회원가입
    signupButton
      .rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .map { RegisterUserInfoReactor.Action.signupWithEmail }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 각 textfield 입력값에 따라 경고라벨 설정
    reactor.state
      .compactMap(\.validationMessagee)
      .withUnretained(self)
      .subscribe(onNext: { (vc, message) in
        vc.setTextFieldAlert(with: message)
      })
      .disposed(by: disposeBag)

    // 회원가입 버튼 활성화 여부
    reactor.state
      .map(\.isSignupBtnEnable)
      .withUnretained(self)
      .subscribe(onNext: { (vc, isActivate) in
        vc.signupButton.isEnabled = isActivate
        vc.signupButton.backgroundColor = isActivate ? .mainBlue : .unableGray
      })
      .disposed(by: disposeBag)
    
    // 회원가입 결과
    reactor.state
      .compactMap(\.isSignupSucess)
      .subscribe(onNext: { result in
        let nextScreen: AuthStep = result ? .completeSignupIsRequired : .popupScreenIsRequired(type: .error)
        self.stepper.steps.accept(nextScreen)
      })
      .disposed(by: disposeBag)
  }
  
  /// TextField 유효성 확인 후 AlertLabel 설정
  /// - Parameter message: AlertLabel의 메세지
  private func setTextFieldAlert(with message: ValidationMessage){
    switch message {
    case .invalidEmail, .duplicateEmail:
      emailTextField.setValidationMessage(message.message, isHidden: false)
    case .validEmail:
      emailTextField.validationLabel.isHidden = true
   
    case .invalidPassword:
      passwordTextField.setValidationMessage(message.message, isHidden: false)
    case .validPassword:
      passwordTextField.validationLabel.isHidden = true
      
    case .notEqualPassword:
      checkPasswordTextField.setValidationMessage(message.message, isHidden: false)
    case .equalPassword:
      checkPasswordTextField.validationLabel.isHidden = true
    
    case .duplicateNickname, .isInvalidNickname:
      nicknameTextField.setValidationMessage(message.message, isHidden: false)
    case .validNickname:
      nicknameTextField.validationLabel.isHidden = true
    }
  }
}

// MARK: 팝업뷰 Delegate
extension RegisterUserInfoViewController: PopupViewDelegate {}
