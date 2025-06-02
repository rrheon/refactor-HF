//
//  SettingViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/8/24.
//

import UIKit
import SafariServices

import Then
import SnapKit

// 설정 추가하기 - 서비스 : 알림. 개인정보처리방침. 서비스. 이용방침. 계정 : 탈퇴 로그아웃, 메세지 수신여부 여자만 남자만 전체수신 전체차단

// 채팅방 생성하기 전에 userdatainfo에 접근해서 messageSetting 확인 -> 기본값은 전체 수신 -> 전체 수신, 수신 차단으로 일단 가자
class SettingViewController: NaviHelper {
  let settingViewModel = SettingViewModel.shared
  
  private lazy var serviceLabel = uihelper.createSingleLineLabel("🛠️ 서비스",
                                                                 .black,
                                                                 .boldSystemFont(ofSize: 20))
  private lazy var serviceView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 10
  }
  //  private lazy var settingAlarmButton = UIButton().then {
  //    $0.setImage(UIImage(named: "AlaramImg"), for: .normal)
  //    $0.setTitle(" 알림", for: .normal)
  //    $0.setTitleColor(.black, for: .normal)
  //  }
  //
  //  private lazy var alarmSwitch = UISwitch().then { $0.onTintColor = .mainBlue }
  
  private lazy var personInfoButton = UIButton().then {
    $0.setImage(UIImage(named: "PersonInfoImg"), for: .normal)
    $0.setTitle(" 개인정보 처리방침", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addAction(UIAction { _ in
      self.moveToSafari(url: URLSet.personInfo.rawValue)
    }, for: .touchUpInside)
  }
  
  private lazy var serviceInfoButton = UIButton().then {
    $0.setImage(UIImage(named: "ServiceImg"), for: .normal)
    $0.setTitle(" 서비스 이용방침", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addAction(UIAction { _ in
      self.moveToSafari(url: URLSet.seriveInfo.rawValue)
    }, for: .touchUpInside)
  }
  
  private lazy var contactButton = UIButton().then {
    $0.setImage(UIImage(named: "ChatImg"), for: .normal)
    $0.setTitle(" 문의하기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addAction(UIAction { _ in
      self.moveToSafari(url: URLSet.contact.rawValue)
    }, for: .touchUpInside)
  }
  
  private lazy var accountView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 10
  }
  private lazy var accountLabel = uihelper.createSingleLineLabel("⭐️ 계정",
                                                                 .black,
                                                                 .boldSystemFont(ofSize: 20))
  private lazy var messageOptionButton = UIButton().then {
    $0.setImage(UIImage(named: "MessgaeImg"), for: .normal)
    $0.setTitle(" 메세지 수신거부", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }
  
  private lazy var messageOptionSwitch = UISwitch().then { $0.onTintColor = .mainBlue }
  
  private lazy var deleteAccountButton = UIButton().then {
    $0.setImage(UIImage(named: "MessgaeImg"), for: .normal)
    $0.setTitle(" 회원탈퇴", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addAction(UIAction { _ in
      self.showPopupView("회원탈퇴 할까요?"){
        self.removeAccount()
      }
    }, for: .touchUpInside)
  }
  
  private lazy var logoutButton = UIButton().then {
    $0.setImage(UIImage(named: "LogoutImg"), for: .normal)
    $0.setTitle(" 로그아웃", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addAction(UIAction { _ in
      self.showPopupView("로그아웃 할까요?") {
        self.logout()
      }
    }, for: .touchUpInside)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
    
    dataSetting()
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    let rightButton = UIBarButtonItem(title: "완료",
                                      style: .plain,
                                      target: self,
                                      action: #selector(settingOptions))
    rightButton.tintColor = .mainBlue
  
    settingNavigationTitle(title: "설정")
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  func setupLayout(){
    [
      //      settingAlarmButton,
      //      alarmSwitch,
      personInfoButton,
      serviceInfoButton,
      contactButton
    ].forEach {
      serviceView.addSubview($0)
    }
    
    [
      messageOptionButton,
      messageOptionSwitch,
      deleteAccountButton,
      logoutButton
    ].forEach {
      accountView.addSubview($0)
    }
    
    [
      serviceLabel,
      serviceView,
      accountLabel,
      accountView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    serviceLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
      $0.leading.equalToSuperview().offset(20)
    }
    
    serviceView.snp.makeConstraints {
      $0.top.equalTo(serviceLabel.snp.bottom).offset(20)
      $0.leading.equalTo(serviceLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(150)
    }
    
    //    settingAlarmButton.snp.makeConstraints {
    //      $0.top.equalTo(serviceView.snp.top).offset(20)
    //      $0.leading.equalTo(serviceView.snp.leading).offset(20)
    //    }
    //
    //    alarmSwitch.snp.makeConstraints {
    //      $0.top.equalTo(settingAlarmButton)
    //      $0.trailing.equalTo(serviceView.snp.trailing).offset(-20)
    //    }
    
    personInfoButton.snp.makeConstraints {
      $0.top.equalTo(serviceView.snp.top).offset(20)
      $0.leading.equalTo(serviceView.snp.leading).offset(20)
    }
    
    serviceInfoButton.snp.makeConstraints {
      $0.top.equalTo(personInfoButton.snp.bottom).offset(20)
      $0.leading.equalTo(personInfoButton)
    }
    
    contactButton.snp.makeConstraints {
      $0.top.equalTo(serviceInfoButton.snp.bottom).offset(20)
      $0.leading.equalTo(personInfoButton)
    }
    
    accountLabel.snp.makeConstraints {
      $0.top.equalTo(serviceView.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    accountView.snp.makeConstraints {
      $0.top.equalTo(accountLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(serviceView)
      $0.height.equalTo(150)
    }
    
    messageOptionButton.snp.makeConstraints {
      $0.top.equalTo(accountView.snp.top).offset(20)
      $0.leading.equalTo(accountView.snp.leading).offset(20)
    }
    
    messageOptionSwitch.snp.makeConstraints {
      $0.top.equalTo(messageOptionButton)
      $0.trailing.equalTo(accountView.snp.trailing).offset(-20)
    }
    
    deleteAccountButton.snp.makeConstraints {
      $0.top.equalTo(messageOptionButton.snp.bottom).offset(20)
      $0.leading.equalTo(accountView.snp.leading).offset(20)
    }
    
    logoutButton.snp.makeConstraints {
      $0.top.equalTo(deleteAccountButton.snp.bottom).offset(20)
      $0.leading.equalTo(deleteAccountButton)
    }
  }
  
  func dataSetting(){
    self.settingViewModel.getUserData(dataType: "messageOption" ) { result in
      if result == "true" { self.messageOptionSwitch.isOn = true}
      else { self.messageOptionSwitch.isOn = false}
    }
  }
  
  func removeAccount(){
    self.settingViewModel.removeAccount()
    logout()
  }
  
  func logout(){
//    if let navigationController = self.navigationController {
//      navigationController.dismiss(animated: true)
//      navigationController.popToRootViewController(animated: false)
//      
//      let loginVC = LoginViewController()
//      loginVC.modalPresentationStyle = .overFullScreen
//      navigationController.present(loginVC, animated: true)
//    }
  }
  
  func showPopupView(_ desc: String, action: (() -> Void)?) {
    let popupVC = PopupViewController(title: "✅",
                                      desc: desc,
                                      rightButtonTilte: "확인",
                                      checkCompleteButton: false)
    popupVC.modalPresentationStyle = .overFullScreen
    popupVC.popupView.rightButtonAction = { [weak self] in
      self?.dismiss(animated: true) {
        action?()
      }
    }
    self.present(popupVC, animated: false)
  }
  
  @objc func settingOptions(){
    self.settingViewModel.settingMessageOption(String(messageOptionSwitch.isOn))
    self.navigationController?.popViewController(animated: true)
  }
}
