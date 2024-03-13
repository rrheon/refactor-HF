//
//  CraeteViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import UIKit

import SnapKit

final class CreatePostViewController: NaviHelper {
  private lazy var setTimeLabel = UIHelper.shared.createSingleLineLabel("시간대 ⏰")
  private lazy var setTimeTextfield = UIHelper.shared.createGeneralTextField("메세지를 입력해주세요.")
  
  private lazy var selectWorkoutTitle = UIHelper.shared.createSingleLineLabel("운동 종류 🏋🏻")
  private lazy var cardioButton = UIHelper.shared.createButtonWithImage("유산소","EmptyCheckboxImg")
  private lazy var chestButton = UIHelper.shared.createButtonWithImage("가슴","EmptyCheckboxImg")
  private lazy var backButton = UIHelper.shared.createButtonWithImage("등","EmptyCheckboxImg")
  private lazy var lowerBodyButton = UIHelper.shared.createButtonWithImage("하체","EmptyCheckboxImg")
  private lazy var shoulderButton = UIHelper.shared.createButtonWithImage("어깨","EmptyCheckboxImg")
  private lazy var choiceWorkoutStackView = UIHelper.shared.createStackView(axis: .vertical,
                                                                            spacing: 10)
  
  private lazy var selectGenderTitle = UIHelper.shared.createSingleLineLabel("성별 🚻")
  private lazy var selectMaleButton = UIHelper.shared.createSelectButton("남자만")
  private lazy var selectFemaleButton = UIHelper.shared.createSelectButton("여자만")
  private lazy var selectAllButton = UIHelper.shared.createSelectButton("무관")
  private lazy var selectGenderButtonStackView = UIHelper.shared.createStackView(axis: .horizontal,
                                                                                 spacing: 10)
  
  private lazy var writeDetailInfoLabel = UIHelper.shared.createSingleLineLabel("내용")
  private lazy var writeDetailInfoTextView = UIHelper.shared.createGeneralTextView("내용을 입력하세요.")
  
  private lazy var writerProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var wirterNicknameLabel = UIHelper.shared.createSingleLineLabel("닉네임")
  private lazy var enterPostButton = UIHelper.shared.createHealfButton("매칭 등록하기 📬",
                                                                       .mainBlue, .white)
  
  let createPostViewModel = CreatePostViewModel()
  var workoutTypes: [String] = []
  var selectedGender: String = ""
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItemSetting()
    
    view.backgroundColor = .white
    
    setupLayout()
    makeUI()
    
    registerButtonFunc()
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    settingNavigationTitle(title: "매칭 등록하기 📬")
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      cardioButton,
      chestButton,
      backButton,
      lowerBodyButton,
      shoulderButton
    ].forEach {
      choiceWorkoutStackView.addArrangedSubview($0)
    }
    
    [
      selectMaleButton,
      selectFemaleButton,
      selectAllButton
    ].forEach {
      selectGenderButtonStackView.addArrangedSubview($0)
    }
    
    [
      setTimeLabel,
      setTimeTextfield,
      selectWorkoutTitle,
      choiceWorkoutStackView,
      selectGenderTitle,
      selectGenderButtonStackView,
      writeDetailInfoLabel,
      writeDetailInfoTextView,
      writerProfileImageView,
      wirterNicknameLabel,
      enterPostButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    setTimeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    setTimeTextfield.layer.borderColor = UIColor.lightGray.cgColor
    setTimeTextfield.layer.cornerRadius = 5
    setTimeTextfield.snp.makeConstraints {
      $0.top.equalTo(setTimeLabel.snp.bottom).offset(5)
      $0.leading.equalTo(setTimeLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(30)
    }
    
    selectWorkoutTitle.snp.makeConstraints {
      $0.top.equalTo(setTimeTextfield.snp.bottom).offset(10)
      $0.leading.equalTo(setTimeLabel)
    }
    
    choiceWorkoutStackView.alignment = .leading
    choiceWorkoutStackView.backgroundColor = .clear
    choiceWorkoutStackView.snp.makeConstraints {
      $0.top.equalTo(selectWorkoutTitle.snp.bottom).offset(5)
      $0.leading.equalTo(setTimeLabel)
    }
    
    selectGenderTitle.snp.makeConstraints {
      $0.top.equalTo(choiceWorkoutStackView.snp.bottom).offset(10)
      $0.leading.equalTo(setTimeLabel)
    }
    
    selectGenderButtonStackView.distribution = .fillEqually
    selectGenderButtonStackView.backgroundColor = .clear
    selectGenderButtonStackView.snp.makeConstraints {
      $0.top.equalTo(selectGenderTitle.snp.bottom).offset(10)
      $0.leading.equalTo(setTimeLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    writeDetailInfoLabel.snp.makeConstraints {
      $0.top.equalTo(selectGenderButtonStackView.snp.bottom).offset(10)
      $0.leading.equalTo(setTimeLabel)
    }
    
    writeDetailInfoTextView.snp.makeConstraints {
      $0.top.equalTo(writeDetailInfoLabel.snp.bottom).offset(10)
      $0.leading.equalTo(setTimeLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(167)
    }
    
    writerProfileImageView.snp.makeConstraints {
      $0.top.equalTo(writeDetailInfoTextView.snp.bottom).offset(50)
      $0.leading.equalTo(setTimeLabel)
    }
    
    wirterNicknameLabel.snp.makeConstraints {
      $0.centerY.equalTo(writerProfileImageView)
      $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
    }
    
    enterPostButton.snp.makeConstraints {
      $0.centerY.equalTo(writerProfileImageView)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(41)
      $0.width.equalTo(151)
    }
  }
  
  func registerButtonFunc(){
    enterPostButton.addAction(UIAction { _ in
      self.registerPost()
    }, for: .touchUpInside)
    
    let genderButtons = [selectAllButton, selectMaleButton, selectFemaleButton]
    genderButtons.forEach { button in
      button.addAction(UIAction { _ in
        self.genderButtonTapped(button)
      }, for: .touchUpInside)
    }
    
    let workoutTypeButtons = [cardioButton, chestButton, backButton,
                              lowerBodyButton, shoulderButton]
    workoutTypeButtons.forEach { button in
      button.addAction(UIAction { _ in
        self.workoutTypeButtonTapped(button)
      }, for: .touchUpInside)
    }
  }
  
  func workoutTypeButtonTapped(_ sender: UIButton) {
    guard let workout = sender.titleLabel?.text else { return }
    
    if sender.currentImage == UIImage(named: "CheckboxImg") {
      sender.setImage(UIImage(named: "EmptyCheckboxImg"), for: .normal)
      workoutTypes.removeAll { $0 == workout }
    } else {
      sender.setImage(UIImage(named: "CheckboxImg"), for: .normal)
      workoutTypes.append(workout)
    }
  }
  
  func genderButtonTapped(_ sender: UIButton) {
    [
      selectAllButton,
      selectMaleButton,
      selectFemaleButton
    ].forEach {
      $0.layer.borderColor = UIColor(hexCode: "#D8DCDE").cgColor
      $0.setTitleColor(UIColor(hexCode: "#A1AAB0"), for: .normal)
    }
    
    sender.layer.borderColor = UIColor.mainBlue.cgColor
    sender.setTitleColor(.mainBlue, for: .normal)
    
    guard let gender = sender.titleLabel?.text else { return }
    selectedGender = gender
  }
  
  func registerPost(){
    guard let time = setTimeTextfield.text,
          let info = writeDetailInfoTextView.text else { return }
    
    self.createPostViewModel.createPost(time, self.workoutTypes, self.selectedGender, info)
  }
}

