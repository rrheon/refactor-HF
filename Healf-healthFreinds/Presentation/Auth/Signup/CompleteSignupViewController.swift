//
//  CompleSignupViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2/28/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

/// Healf-front-SignupFlow
/// Healf-front-CompleteSignupScreen
/// 회원가입 완료 화면
final class CompleteSignupViewController: UIViewController {
  var disposeBag: DisposeBag = DisposeBag()
  
  private lazy var completedSignupImage = UIImageView().then {
    $0.image = UIImage(named: BtnImages.completedSignupBtn)
  }
  
  private lazy var mainImageView = UIImageView().then {
    $0.image = UIImage(named: BtnImages.completedSingupMainImg)
  }
  
  private lazy var mainTitleLabel = UILabel().then {
    $0.text =  LabelTitle.completedSignupTitle
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 17)
  }
  
  private lazy var startButton = UIHelper.shared.createHealfButton(BtnTitle.startBtn, .mainBlue, .white)

  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    makeUI()
    
    // 시작버튼 탭
    // 회원가입 Flow 종료
    startButton.rx.tap
      .subscribe(onDisposed: {
        self.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - makeUI
  
  func makeUI(){
    view.addSubview(completedSignupImage)
    completedSignupImage.snp.makeConstraints {
      $0.top.equalToSuperview().offset(150)
      $0.centerX.equalToSuperview()
    }
    
    view.addSubview(mainImageView)
    mainImageView.snp.makeConstraints {
      $0.top.equalTo(completedSignupImage.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
  
    view.addSubview(mainTitleLabel)
    mainTitleLabel.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom).offset(50)
      $0.centerX.equalToSuperview()
    }
    
    view.addSubview(startButton)
    startButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-150)
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalTo(mainTitleLabel)
      $0.height.equalTo(50)
    }
  }
}
