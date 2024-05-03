//
//  CompleSignupViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2/28/24.
//

import UIKit

import SnapKit
import Then

final class CompleSignupViewController: NaviHelper {
  
  private lazy var mainImageView = UIImageView().then { $0.image = UIImage(named: "MainTitleImg") }
  private lazy var mainTitleLabel = UIHelper.shared.createSingleLineLabel(
    "가입을 완료했어요!\n로그인하여 운동친구를 찾아보세요.",
    .black,
    .boldSystemFont(ofSize: 17))
  private lazy var startButton = UIHelper.shared.createHealfButton("시작하기", .mainBlue, .white)

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
  }
  
  override func navigationItemSetting() {}
  
  // MARK: - setupLayout
  func setupLayout() {
    [
      mainImageView,
      mainTitleLabel,
      startButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(50)
    }
    
    mainTitleLabel.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
    
    startButton.addAction(UIAction { _ in
      self.startButtonTapped()
    } , for: .touchUpInside)
    startButton.snp.makeConstraints {
      $0.top.equalTo(mainTitleLabel.snp.bottom).offset(50)
      $0.centerX.equalToSuperview()
    }
  }
  
  func startButtonTapped(){
    let loginVC = LoginViewController()
    
    let loginVCWithNavi = UINavigationController(rootViewController: loginVC)
    loginVCWithNavi.modalPresentationStyle = .fullScreen
    
    present(loginVCWithNavi, animated: true, completion: nil)  }
}
