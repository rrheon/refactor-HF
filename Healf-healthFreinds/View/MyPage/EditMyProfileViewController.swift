//
//  EditMyProfileViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/4/24.
//

import UIKit

import SnapKit

class EditMyProfileViewController: NaviHelper {
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
    imageView.layer.cornerRadius = 15
    return imageView
  }()
  
  private lazy var nicknameLabel = uihelper.createSingleLineLabel("닉네임",
                                                                  .mainBlue,
                                                                  .boldSystemFont(ofSize: 14))
  private lazy var nicknameTextField = uihelper.createLoginTextField("닉네임")
  
  private lazy var introduceLabel = uihelper.createSingleLineLabel("소개",
                                                                  .mainBlue,
                                                                  .boldSystemFont(ofSize: 14))
  private lazy var introduceTextFiled = uihelper.createLoginTextField("소개")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
  }
  
  func setupLayout(){
    [
      profileImageView,
      nicknameLabel,
      nicknameTextField,
      introduceLabel,
      introduceTextFiled
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(100)
      $0.centerX.equalToSuperview()
    }
    
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    nicknameTextField.snp.makeConstraints {
      $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    introduceLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameTextField.snp.bottom).offset(30)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    introduceTextFiled.snp.makeConstraints {
      $0.top.equalTo(introduceLabel.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
  }

  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    settingNavigationTitle(title: "프로필 편집")
    
    let completeImg = UIImage(named: "CompleteImg")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                     style: .plain,
                                     target: self,
                                     action: #selector(completeButtonTapped))
    completeButton.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)

    self.navigationItem.rightBarButtonItem = completeButton
  }
  
  @objc func completeButtonTapped(){
    navigationController?.popViewController(animated: true)
  }
}
