//
//  CraeteViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import UIKit

import SnapKit

final class CreatePostViewController: NaviHelper {
  private lazy var setTimeLabel = uihelper.createSingleLineLabel("시간대 ⏰")
  private lazy var setTimeTextfield = uihelper.createGeneralTextField("메세지를 입력해주세요.")
  
  private lazy var selectWorkoutTitle = uihelper.createSingleLineLabel("운동 종류 🏋🏻")
  private lazy var cardioButton = uihelper.createButtonWithImage("유산소","EmptyCheckboxImg")
  private lazy var chestButton = uihelper.createButtonWithImage("가슴","EmptyCheckboxImg")
  private lazy var backButton = uihelper.createButtonWithImage("등","EmptyCheckboxImg")
  private lazy var lowerBodyButton = uihelper.createButtonWithImage("하체","EmptyCheckboxImg")
  private lazy var shoulderButton = uihelper.createButtonWithImage("어깨","EmptyCheckboxImg")
  private lazy var choiceWorkoutStackView = uihelper.createStackView(axis: .vertical,
                                                                            spacing: 10)
  
  private lazy var selectGenderTitle = uihelper.createSingleLineLabel("성별 🚻")
  private lazy var selectMaleButton = uihelper.createSelectButton("남자만")
  private lazy var selectFemaleButton = uihelper.createSelectButton("여자만")
  private lazy var selectAllButton = uihelper.createSelectButton("무관")
  private lazy var selectGenderButtonStackView = uihelper.createStackView(axis: .horizontal,
                                                                                 spacing: 10)
  
  private lazy var writeDetailInfoLabel = uihelper.createSingleLineLabel("내용")
  private lazy var writeDetailInfoTextView = uihelper.createGeneralTextView("내용을 입력하세요.")
  
  private lazy var writerProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var wirterNicknameLabel = uihelper.createSingleLineLabel("닉네임")
  private lazy var enterPostButton = uihelper.createHealfButton("매칭 등록하기 📬", .mainBlue, .white)
  
  let createPostViewModel = CreatePostViewModel()
  var workoutTypes: [String] = []
  var selectedGender: String = ""
  
  var modifyPostedData: CreatePostModel?
  
  init(postedData: CreatePostModel? = nil) {
    super.init()

    self.modifyPostedData = postedData
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItemSetting()
    
    view.backgroundColor = .white
    
    setupLayout()
    makeUI()
        
    registerButtonFunc()
    settingModifyValue()
    
    hideKeyboardWhenTappedAround()
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
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
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
  
  // MARK: - button Func register
  func registerButtonFunc(){
    enterPostButton.addAction(UIAction { _ in
      self.processPost(isModify: false) {
        self.navigationController?.popViewController(animated: true)
        self.uihelper.showToast(message: "✅ 게시글이 등록되었어요!")
      }
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
        self.workoutTypeButtonTapped(button) { workouts in
          self.workoutTypes.append(contentsOf: workouts)
        }
      }, for: .touchUpInside)
    }
  }
  
  // MARK: - genderButtonTapped
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
  
  // MARK: - registerPost
  func processPost(isModify: Bool, completion: @escaping () -> Void) {
    guard let time = setTimeTextfield.text,
          let info = writeDetailInfoTextView.text else { return }
    
    if isModify {
      self.createPostViewModel.createPost(time, self.workoutTypes,
                                          self.selectedGender, info, modifyPostedData?.postedDate)
    } else {
      self.createPostViewModel.createPost(time, self.workoutTypes, self.selectedGender, info)
    }
    completion()
  }

  
  // MARK: - settingModifyValue
  func settingModifyValue(){
    guard let modifyPostedData = modifyPostedData else { return }
    
    settingNavigationTitle(title: "게시글 수정하기 📬")
    
    setTimeTextfield.text = modifyPostedData.time
    writeDetailInfoTextView.text = modifyPostedData.info
    wirterNicknameLabel.text = modifyPostedData.userNickname
    
    [
      selectMaleButton,
      selectFemaleButton,
      selectAllButton
    ].forEach {
      if $0.currentTitle == modifyPostedData.gender {
        $0.isSelected = true
        genderButtonTapped($0)
      }
    }
    
    for button in [cardioButton, chestButton, backButton, lowerBodyButton, shoulderButton] {
      if let buttonTitle = button.titleLabel?.text,
         modifyPostedData.workoutTypes.contains(buttonTitle) {
        button.isSelected = true
        workoutTypeButtonTapped(button) { workouts in
          self.workoutTypes.append(contentsOf: workouts)
        }
      }
    }

    enterPostButton.removeTarget(nil, action: nil, for: .allEvents)

    enterPostButton.addAction(UIAction { _ in
      self.processPost(isModify: true) {
        self.navigationController?.popViewController(animated: true)
        self.uihelper.showToast(message: "✅ 게시글이 등록되었어요!")
      }
    }, for: .touchUpInside)
  }
}

