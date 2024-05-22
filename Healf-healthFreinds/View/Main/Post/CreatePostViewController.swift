//
//  CraeteViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import UIKit

import SnapKit
import Then
import DropDown

final class CreatePostViewController: NaviHelper {
  private lazy var selectLocationButton = UIButton().then {
    $0.setTitle("📍 지역: 전 체 ", for: .normal)
    $0.backgroundColor = .white
    $0.setTitleColor(.black, for: .normal)
    $0.layer.cornerRadius = 10
    $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
    $0.setImage(UIImage(named: "SearchImg"), for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    $0.addAction(UIAction { _ in
      self.selectLocationButtonTapped()
    }, for: .touchUpInside)
  }
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    SearchViewModel.shared.updateAllPosts(location: "전 체")
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
    
    showPopupViewWithOneButton("부적절하거나 불쾌감을 줄 수 있는 컨텐츠를 게시할 경우 제재를 받을 수 있습니다.")
    
    setupKeyboardEvent()
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
      selectLocationButton,
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
    settingViewSize = UIScreen.main.isWiderThan375pt ? 30 : 10
    selectLocationButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(settingViewSize)
      $0.leading.equalToSuperview().offset(20)
    }
    
    selectedTimeLabel.snp.makeConstraints {
      $0.top.equalTo(selectLocationButton)
      $0.leading.equalTo(selectLocationButton)
    }
    
    startTimeLabel.snp.makeConstraints {
      $0.top.equalTo(selectLocationButton.snp.bottom).offset(30)
      $0.leading.equalTo(selectedTimeLabel)
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
      $0.leading.equalTo(selectLocationButton)
    }
    
    choiceWorkoutStackView.alignment = .leading
    choiceWorkoutStackView.backgroundColor = .clear
    choiceWorkoutStackView.snp.makeConstraints {
      $0.top.equalTo(selectWorkoutTitle.snp.bottom).offset(5)
      $0.leading.equalTo(selectLocationButton)
    }
    
    selectGenderTitle.snp.makeConstraints {
      $0.top.equalTo(choiceWorkoutStackView.snp.bottom).offset(10)
      $0.leading.equalTo(selectLocationButton)
    }
    
    selectGenderButtonStackView.distribution = .fillEqually
    selectGenderButtonStackView.backgroundColor = .clear
    selectGenderButtonStackView.snp.makeConstraints {
      $0.top.equalTo(selectGenderTitle.snp.bottom).offset(10)
      $0.leading.equalTo(selectLocationButton)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    writeDetailInfoLabel.snp.makeConstraints {
      $0.top.equalTo(selectGenderButtonStackView.snp.bottom).offset(10)
      $0.leading.equalTo(selectLocationButton)
    }
    
    settingViewSize = UIScreen.main.isWiderThan375pt ? 167 : 120
    writeDetailInfoTextView.delegate = self
    writeDetailInfoTextView.snp.makeConstraints {
      $0.top.equalTo(writeDetailInfoLabel.snp.bottom).offset(10)
      $0.leading.equalTo(selectLocationButton)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(settingViewSize)
    }
    
    settingViewSize = UIScreen.main.isWiderThan375pt ? 50 : 10
    enterPostButton.snp.makeConstraints {
      $0.top.equalTo(writeDetailInfoTextView.snp.bottom).offset(settingViewSize)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(41)
      $0.width.equalTo(151)
    }
  }
  
  // MARK: - button Func register
  func registerButtonFunc(){
    enterPostButton.addAction(UIAction { _ in
      self.processPost(location: "", isModify: false) {
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
  func processPost(location: String,
                   isModify: Bool,
                   completion: @escaping () -> Void) {
      guard let info = writeDetailInfoTextView.text,
            let location = selectLocationButton.currentTitle else { return }
      let time = "\(selectedStartTime) ~ \(selectedEndTime)"
      let fileterdLocation = filteringLocation(location: location)
      createPostViewModel.createPost(time,
                                     self.workoutTypes,
                                     self.selectedGender,
                                     info,
                                     fileterdLocation,
                                     isModify ? self.modifyPostedData?.postedDate : nil)
      
      completion()
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
      self.processPost(location: "", isModify: true) {
        self.navigationController?.popViewController(animated: true)
        self.uihelper.showToast(message: "✅ 게시글이 등록되었어요!")
      }
    }, for: .touchUpInside)
  }
}

extension CreatePostViewController {
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
  
  func selectLocationButtonTapped(){
    let dropDownView = DropDown()
    dropDownView.dataSource = self.locations
    dropDownView.cellHeight = 40
    dropDownView.separatorColor = .black
    dropDownView.textFont = .boldSystemFont(ofSize: 20)
    dropDownView.anchorView = selectLocationButton
    dropDownView.cornerRadius = 5.0
    dropDownView.offsetFromWindowBottom = 80
    dropDownView.bottomOffset = CGPoint(x: 0, y: selectLocationButton.bounds.height)
    
    dropDownView.direction = .bottom
    dropDownView.show()
    
    dropDownView.selectionAction = { [unowned self] (index: Int, item: String) in
      selectLocationButton.setTitle("📍 지역: \(item)", for: .normal)
    }
  }
  
  func filteringLocation(location: String) -> String{
    let filteredLocation = location.components(separatedBy: "📍 지역:")
    
    // 나눠진 문자열의 두 번째 부분을 가져옵니다.
    if filteredLocation.count > 1 {
      let extractedValue = filteredLocation[1].trimmingCharacters(in: .whitespacesAndNewlines)
      return extractedValue
    } else {
      return "전 체"
    }
  }
}
