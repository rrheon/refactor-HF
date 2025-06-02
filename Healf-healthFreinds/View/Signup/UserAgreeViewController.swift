//
//  UserAgreeViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/21/24.
//

import UIKit

import SnapKit
import Then

/// Healf-front-SignupFlow
/// Healf-front-UserAgreementScreen
/// 이용약관동의화면
final class UserAgreeViewController: UIViewController {
  var serviceAgreeButtonChecked = false
  var personalInfoAgreeButtonChecked = false
  var moveToPersonalInfoAgreeButtonEnabled = false
  
  private lazy var titleLabel = UILabel().then {
    $0.text = "이용약관에 동의해주세요\n서비스 이용을 위해서 약관 동의가 필요해요"
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 20)
    $0.numberOfLines = 0
  }
  
  private lazy var serviceAgreeButton = UIButton().then {
    $0.setImage(UIImage(named: "EmptyCheckboxImg"), for: .normal)
    $0.setTitle(" [필수] 서비스 이용약관 동의", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addTarget(self, action: #selector(agreeButtonTapped(_:)), for: .touchUpInside)
  }

  private lazy var moveToServiceAgreeButton = UIButton().then {
    $0.setImage(UIImage(named: "RightArrowImg"), for: .normal)
    $0.setTitleColor(.black, for: .normal)
//    $0.addAction(UIAction { _ in
//      self.moveToSafari(url: URLSet.seriveInfo.rawValue)
//    }, for: .touchUpInside)
  }

  private lazy var personalInfoAgreeButton = UIButton().then {
    $0.setImage(UIImage(named: "EmptyCheckboxImg"), for: .normal)
    $0.setTitle(" [필수] 개인정보 수집 및 이용 동의", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addTarget(self, action: #selector(agreeButtonTapped(_:)), for: .touchUpInside)
  }
  
  private lazy var moveToPersonalInfoAgreeButton = UIButton().then {
    $0.setImage(UIImage(named: "RightArrowImg"), for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.isEnabled = false
//    $0.addAction(UIAction { _ in
//      self.moveToSafari(url: URLSet.personInfo.rawValue)
//    }, for: .touchUpInside)
  }
  
  private lazy var moveToNextVCButton = UIHelper.shared.createHealfButton("로그인", .lightGray, .white)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
        
    makeUI()
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
    
    view.addSubview(moveToServiceAgreeButton)
    moveToServiceAgreeButton.snp.makeConstraints {
      $0.top.equalTo(serviceAgreeButton)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    view.addSubview(personalInfoAgreeButton)
    personalInfoAgreeButton.snp.makeConstraints {
      $0.top.equalTo(serviceAgreeButton.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    view.addSubview(moveToPersonalInfoAgreeButton)
    moveToPersonalInfoAgreeButton.snp.makeConstraints {
      $0.top.equalTo(personalInfoAgreeButton)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    view.addSubview(moveToNextVCButton)
    moveToNextVCButton.snp.makeConstraints {
      $0.bottom.equalTo(view.snp.bottom).offset(-50)
      $0.leading.equalToSuperview().offset(30)
      $0.trailing.equalToSuperview().offset(-30)
      $0.height.equalTo(50)
    }
  }
  
  @objc func agreeButtonTapped(_ sender: UIButton) {
    let image = sender.currentImage == UIImage(named: "CheckboxImg") ? "EmptyCheckboxImg" : "CheckboxImg"
    sender.setImage(UIImage(named: image), for: .normal)
    
    if sender == serviceAgreeButton {
        serviceAgreeButtonChecked.toggle()
    } else if sender == personalInfoAgreeButton {
        personalInfoAgreeButtonChecked.toggle()
    }
    updateMoveToPersonalInfoAgreeButtonState()
  }
  
  private func updateMoveToPersonalInfoAgreeButtonState() {
    moveToPersonalInfoAgreeButtonEnabled = serviceAgreeButtonChecked && personalInfoAgreeButtonChecked
    moveToNextVCButton.isEnabled = moveToPersonalInfoAgreeButtonEnabled
    moveToNextVCButton.backgroundColor = moveToPersonalInfoAgreeButtonEnabled ? .mainBlue : .lightGray
  }
}
