//
//  UserAgreeViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/21/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa


/// Healf-front-SignupFlow
/// Healf-front-UserAgreementScreen
/// 이용약관동의화면
final class UserAgreeViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  private let stepper: AuthStepper
  private let reactor: UserAgreementReactor
  
  private lazy var titleLabel = UILabel().then {
    $0.text = LabelTitle.userAgreementTitle
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 20)
    $0.numberOfLines = 0
  }
  
  private lazy var serviceAgreeButton = UIButton().then {
    $0.setImage(UIImage(named: BtnImages.empty), for: .normal)
    $0.setImage(UIImage(named: BtnImages.checked), for: .selected)
    $0.setTitle(BtnTitle.serviceAgreement, for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }
  

  private lazy var moveToServicePageButton = UIButton().then {
    $0.setImage(UIImage(named: BtnImages.arrow), for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  private lazy var personalInfoAgreeButton = UIButton().then {
    $0.setImage(UIImage(named: BtnImages.empty), for: .normal)
    $0.setImage(UIImage(named: BtnImages.checked), for: .selected)
    $0.setTitle(BtnTitle.personalInfoAgreement, for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }
  
  private lazy var moveToPersonalInfoPageButton = UIButton().then {
    $0.setImage(UIImage(named: BtnImages.arrow), for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }
  
  private lazy var nextButton = UIHelper.shared.createHealfButton(BtnTitle.next, .lightGray, .white)
  
  init(reactor: UserAgreementReactor, stepper: AuthStepper) {
    self.reactor = reactor
    self.stepper = stepper
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
        
    leftButtonSetting()
    makeUI()
    
    bind(reactor: reactor)
  }
  
  func makeUI(){
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(150)
      $0.leading.equalToSuperview().offset(30)
    }
    
    view.addSubview(serviceAgreeButton)
    serviceAgreeButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(50)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    view.addSubview(moveToServicePageButton)
    moveToServicePageButton.snp.makeConstraints {
      $0.top.equalTo(serviceAgreeButton)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    view.addSubview(personalInfoAgreeButton)
    personalInfoAgreeButton.snp.makeConstraints {
      $0.top.equalTo(serviceAgreeButton.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    view.addSubview(moveToPersonalInfoPageButton)
    moveToPersonalInfoPageButton.snp.makeConstraints {
      $0.top.equalTo(personalInfoAgreeButton)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    view.addSubview(nextButton)
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(view.snp.bottom).offset(-50)
      $0.leading.equalToSuperview().offset(30)
      $0.trailing.equalToSuperview().offset(-30)
      $0.height.equalTo(50)
    }
  }
  
  private func bind(reactor: UserAgreementReactor) {
    // 서비스이용약관 동의버튼
    serviceAgreeButton.rx.tap
      .map { UserAgreementReactor.Action.toggleServiceAgree }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    moveToServicePageButton.rx.tap
      .map { UserAgreementReactor.Action.servicePageTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 개인정보활용 동의버튼
    personalInfoAgreeButton.rx.tap
      .map { UserAgreementReactor.Action.togglePersonalAgree }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    moveToPersonalInfoPageButton.rx.tap
      .map { UserAgreementReactor.Action.personalInfoPageTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 다음 버튼
    nextButton.rx.tap
      .subscribe(onNext: { _ in
        self.stepper.steps.accept(AuthStep.inputUserInfoScreenIsRequired)
      })
      .disposed(by: disposeBag)
    
    
    reactor.state
      .map(\.isServiceAgreed)
      .distinctUntilChanged()
      .bind(to: serviceAgreeButton.rx.isSelected )
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isPersonalAgreed }
      .bind(to: personalInfoAgreeButton.rx.isSelected )
      .disposed(by: disposeBag)
    
    reactor.state
      .compactMap(\.url)
      .distinctUntilChanged()
      .subscribe(onNext: { url in
        self.stepper.steps.accept(AuthStep.safariScreenIsRequired(url: url))
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isNextEnable }
      .withUnretained(self)
      .subscribe(onNext: { (vc,isEnabled) in
        vc.nextButton.isEnabled = isEnabled
        vc.nextButton.backgroundColor = !isEnabled ? .lightGray : .mainBlue
      })
      .disposed(by: disposeBag)
  }
  
  /*
   고민 화면을 dismiss / pop 하는 것도 reactor에서 처리하는게 좋은가?
   결국 reactor의 step을 이용해서 처리하는건데 vc에서 직접 dismiss / pop 해도 화면을 생성해서 이동하는 것이 아니기 때문에 괜찮을거 같다
   화면을 직접 vc에서 생성해서 이동하면 vc가 생성한 화면에 대해서 알고 있기 때문에 안된다고 판단
   */
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    self.navigationController?.dismiss(animated: true)
  }
}
