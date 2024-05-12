//
//  CraeteViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import UIKit

import SnapKit
import Then

final class CreatePostViewController: NaviHelper {
  private lazy var setTimeLabel = uihelper.createSingleLineLabel("시간대 ⏰")
  private lazy var selectedTimeLabel = uihelper.createSingleLineLabel("")
  private lazy var startTimeLabel = uihelper.createSingleLineLabel("시작시간:")
  private lazy var endTimeLabel = uihelper.createSingleLineLabel("종료시간:")
  private lazy var startTimePicker = UIDatePicker().then {
    $0.datePickerMode = .time
    $0.addTarget(self, action: #selector(didChangeTimeDatePicker(_:)), for: .valueChanged)
  }
  
  private lazy var endTimePicker = UIDatePicker().then {
    $0.datePickerMode = .time
    $0.addTarget(self, action: #selector(didChangeTimeDatePicker(_:)), for: .valueChanged)
  }
  
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
  
  private lazy var enterPostButton = uihelper.createHealfButton("매칭 등록하기 📬", .mainBlue, .white)
  
  let createPostViewModel = CreatePostViewModel()
  var workoutTypes: [String] = []
  var selectedGender: String = ""
  var selectedStartTime: String = ""
  var selectedEndTime: String = ""
  
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
      selectedTimeLabel,
      startTimeLabel,
      startTimePicker,
      endTimeLabel,
      endTimePicker,
      selectWorkoutTitle,
      choiceWorkoutStackView,
      selectGenderTitle,
      selectGenderButtonStackView,
      writeDetailInfoLabel,
      writeDetailInfoTextView,
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
    
    selectedTimeLabel.snp.makeConstraints {
      $0.top.equalTo(setTimeLabel)
      $0.leading.equalTo(setTimeLabel.snp.trailing).offset(10)
    }
    
    startTimeLabel.snp.makeConstraints {
      $0.top.equalTo(setTimeLabel.snp.bottom).offset(30)
      $0.leading.equalTo(setTimeLabel)
    }

    startTimePicker.snp.makeConstraints {
      $0.top.equalTo(startTimeLabel)
      $0.leading.equalTo(setTimeLabel.snp.trailing).offset(10)
    }
      
    startTimePicker.snp.makeConstraints {
      $0.top.equalTo(startTimeLabel)
      $0.leading.equalTo(startTimeLabel.snp.trailing).offset(10)
    }
    
    endTimeLabel.snp.makeConstraints {
      $0.top.equalTo(startTimeLabel)
      $0.leading.equalTo(startTimePicker.snp.trailing).offset(10)
    }
    
    endTimePicker.snp.makeConstraints {
      $0.top.equalTo(startTimeLabel)
      $0.leading.equalTo(endTimeLabel.snp.trailing).offset(10)
    }
    
    selectWorkoutTitle.snp.makeConstraints {
      $0.top.equalTo(startTimeLabel.snp.bottom).offset(30)
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
    
    writeDetailInfoTextView.delegate = self
    writeDetailInfoTextView.snp.makeConstraints {
      $0.top.equalTo(writeDetailInfoLabel.snp.bottom).offset(10)
      $0.leading.equalTo(setTimeLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(167)
    }
    
    enterPostButton.snp.makeConstraints {
      $0.top.equalTo(writeDetailInfoTextView.snp.bottom).offset(50)
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
    guard let info = writeDetailInfoTextView.text else { return }
    let time = "\(selectedStartTime) ~ \(selectedEndTime)"
    MypageViewModel.shared.getMyInfomation { data in
      let location = data.location?.components(separatedBy: " ")
      let selectedLoaction = location?[1]
      
      if isModify {
        self.createPostViewModel.createPost(time,
                                            self.workoutTypes,
                                            self.selectedGender, 
                                            info,
                                            self.modifyPostedData?.postedDate,
                                            selectedLoaction)
      } else {
        self.createPostViewModel.createPost(time,
                                            self.workoutTypes,
                                            self.selectedGender,
                                            info,
                                            selectedLoaction)
    
      }
      completion()
    }
  }

  
  // MARK: - settingModifyValue
  func settingModifyValue(){
    guard let modifyPostedData = modifyPostedData else { return }
    
    settingNavigationTitle(title: "게시글 수정하기 📬")
    
    selectedTimeLabel.text = modifyPostedData.time
    writeDetailInfoTextView.text = modifyPostedData.info
    
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

extension CreatePostViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "내용을 입력하세요." {
      textView.text = nil
      textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      textView.text = "내용을 입력하세요."
      textView.textColor = .lightGray
    }
  }
  
  @objc func didChangeTimeDatePicker(_ picker: UIDatePicker) {
    // 서울 시간대 설정
    let seoulTimeZone = TimeZone(identifier: "Asia/Seoul")!
    picker.timeZone = seoulTimeZone
    
    // 시간 형식 설정
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm" // 시:분 형식
    
    // 서울 시간으로 변환된 시간을 출력
    let seoulTime = dateFormatter.string(from: picker.date)
    print("대한민국 서울 시간: \(seoulTime)")
    if picker == startTimePicker { selectedStartTime = seoulTime }
    else { selectedEndTime = seoulTime}
    print(selectedStartTime)
    print(selectedEndTime)

  }
}
