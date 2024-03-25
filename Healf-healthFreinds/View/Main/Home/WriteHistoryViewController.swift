//
//  WritehistoryViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import Cosmos
import SnapKit

final class WriteHistoryViewController: NaviHelper, UITextViewDelegate {
  private lazy var aloneButton = UIHelper.shared.createSelectButton("혼자 했어요")
  private lazy var togetherButton = UIHelper.shared.createSelectButton("같이 했어요")
  private lazy var selectAloneOrTogetherStackView = UIHelper.shared.createStackView(axis: .horizontal,
                                                                                    spacing: 10)
  
  private lazy var aloneOrTogetherLabel = UIHelper.shared.createSingleLineLabel("함께한 사람 👥")
  
  private lazy var friendImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var friendNameLabel = UIHelper.shared.createSingleLineLabel("이름이름")
  private lazy var friendLoactionLabel = UIHelper.shared.createSingleLineLabel("📍 송도")
  private lazy var workoutTimeLabel = UIHelper.shared.createSingleLineLabel("🕖 평일 18:00 - 21:00")
  private lazy var workoutTypeLabel = UIHelper.shared.createSingleLineLabel("🏋🏻 유산소, 하체운동 위주")
  private lazy var friendInfoStackView = UIHelper.shared.createStackView(axis: .vertical,
                                                                         spacing: 5)
  
  private lazy var ratingLabel = UIHelper.shared.createSingleLineLabel("오늘의 운동을 평가해주세요 💯")
  private var cosmosView = CosmosView()
  private lazy var cosmosBackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 10)
  
  private lazy var choiceWorkoutTypeLabel = UIHelper.shared.createSingleLineLabel("어떤 운동을 했나요? 🤷🏻‍♂️")
  private lazy var cardioButton = UIHelper.shared.createButtonWithImage("유산소","EmptyCheckboxImg")
  private lazy var chestButton = UIHelper.shared.createButtonWithImage("가슴","EmptyCheckboxImg")
  private lazy var backButton = UIHelper.shared.createButtonWithImage("등","EmptyCheckboxImg")
  private lazy var lowerBodyButton = UIHelper.shared.createButtonWithImage("하체","EmptyCheckboxImg")
  private lazy var shoulderButton = UIHelper.shared.createButtonWithImage("어깨","EmptyCheckboxImg")
  private lazy var choiceWorkoutStackView = UIHelper.shared.createStackView(axis: .vertical,
                                                                            spacing: 10)
  
  private lazy var commentLabel = UIHelper.shared.createSingleLineLabel("오늘의 코멘트 📝")
  private lazy var commentTextView = UIHelper.shared.createGeneralTextView("코멘트를 입력하세요.")
  private lazy var completeButton = UIHelper.shared.createHealfButton("🙌 오늘 운동 끝!", .mainBlue, .white)
  
  let writeHistoryViewModel = WriteHistoryViewModel()
  var aloneOrTogether: String?
  var workoutTypes: [String] = []
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
    settingCosmosView()
    
    registerButtonFunc()
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    settingNavigationTitle(title: "오늘의 운동을 기록하세요 ✍🏻")
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      aloneButton,
      togetherButton
    ].forEach {
      selectAloneOrTogetherStackView.addArrangedSubview($0)
    }
    
    [
      friendNameLabel,
      friendLoactionLabel,
      workoutTimeLabel,
      workoutTypeLabel
    ].forEach {
      friendInfoStackView.addArrangedSubview($0)
    }
    
    cosmosBackView.addArrangedSubview(cosmosView)
    
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
      selectAloneOrTogetherStackView,
      aloneOrTogetherLabel,
      friendImageView,
      friendInfoStackView,
      ratingLabel,
      cosmosBackView,
      choiceWorkoutTypeLabel,
      choiceWorkoutStackView,
      commentLabel,
      commentTextView,
      completeButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    selectAloneOrTogetherStackView.backgroundColor = .white
    selectAloneOrTogetherStackView.distribution = .fillEqually
    selectAloneOrTogetherStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }

    aloneOrTogetherLabel.isHidden = true
    aloneOrTogetherLabel.snp.makeConstraints {
      $0.top.equalTo(selectAloneOrTogetherStackView.snp.bottom).offset(10)
      $0.leading.equalTo(selectAloneOrTogetherStackView)
    }
    
    friendImageView.isHidden = true
    friendImageView.snp.makeConstraints {
      $0.top.equalTo(aloneOrTogetherLabel.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
      $0.height.equalTo(40)
    }
    
    friendInfoStackView.isHidden = true
    friendInfoStackView.backgroundColor = .clear
    friendInfoStackView.snp.makeConstraints {
      $0.top.equalTo(friendImageView).offset(-10)
      $0.leading.equalTo(friendImageView.snp.trailing).offset(10)
    }
    
    ratingLabel.snp.makeConstraints {
      $0.top.equalTo(selectAloneOrTogetherStackView.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
    }
    
    cosmosBackView.alignment = .center
    cosmosBackView.snp.makeConstraints {
      $0.top.equalTo(ratingLabel.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    choiceWorkoutTypeLabel.snp.makeConstraints {
      $0.top.equalTo(cosmosView.snp.bottom).offset(20)
      $0.leading.equalTo(aloneOrTogetherLabel)
    }
    
    choiceWorkoutStackView.alignment = .leading
    choiceWorkoutStackView.distribution = .fill
    choiceWorkoutStackView.backgroundColor = .clear
    choiceWorkoutStackView.snp.makeConstraints {
      $0.top.equalTo(choiceWorkoutTypeLabel.snp.bottom).offset(10)
      $0.leading.equalTo(choiceWorkoutTypeLabel.snp.leading)
    }
    
    commentLabel.snp.makeConstraints {
      $0.top.equalTo(choiceWorkoutStackView.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
    }
    
    commentTextView.delegate = self
    commentTextView.snp.makeConstraints {
      $0.top.equalTo(commentLabel.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(120)
    }
    
    completeButton.snp.makeConstraints {
      $0.top.equalTo(commentTextView.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(56)
    }
  }
  
  // MARK: - settingCosmosView
  func settingCosmosView(){
    cosmosView.rating = 4
    cosmosView.settings.starSize = 30
    cosmosView.settings.starMargin = 10
    cosmosView.settings.fillMode = .precise

    cosmosView.settings.filledImage = UIImage(named: "FilledStarImg")
    cosmosView.settings.emptyImage = UIImage(named: "EmptyStarImg")
  }
  
  // MARK: - registerButtonFunc
  func registerButtonFunc(){
    let selectButton = [aloneButton, togetherButton]
    selectButton.forEach { button in
      button.addAction(UIAction { _ in
        self.aloneOrTogetherButtonTapped(button)
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
    
    completeButton.addAction(UIAction { _ in
      self.completButtonTapped()
    }, for: .touchUpInside)
  }

  // 같이 일때 화면 이동해서 유저 선택
//    totalSelectMajorStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 70, right: 20) 스택뷰의 바텀 눌리고 줄이고로 공간생성하기
  // MARK: - updateRatingLabel
  func updateRatingLabelPosition(isTogetherSelected: Bool) {
    aloneOrTogetherLabel.isHidden = !isTogetherSelected
    friendImageView.isHidden = !isTogetherSelected
    friendInfoStackView.isHidden = !isTogetherSelected
    
    let topOffset: CGFloat = isTogetherSelected ? 150 : 10
    ratingLabel.snp.remakeConstraints {
      $0.top.equalTo(selectAloneOrTogetherStackView.snp.bottom).offset(topOffset)
      $0.leading.equalTo(aloneOrTogetherLabel)
    }
  }
  
  // MARK: - aloneButtonTapped
  func aloneOrTogetherButtonTapped(_ sender: UIButton){
    [
      aloneButton,
      togetherButton
    ].forEach {
      $0.layer.borderColor = UIColor(hexCode: "#D8DCDE").cgColor
      $0.setTitleColor(UIColor(hexCode: "#A1AAB0"), for: .normal)
    }
    sender.layer.borderColor = UIColor.mainBlue.cgColor
    sender.setTitleColor(.mainBlue, for: .normal)
    
    let isTogetherSelected = (sender == togetherButton)
    if isTogetherSelected {
      let selectPersonVC = SelectPersonViewController()
      selectPersonVC.delegate = self
      navigationController?.pushViewController(selectPersonVC, animated: true)
    }
    updateRatingLabelPosition(isTogetherSelected: isTogetherSelected)
    
    guard let userChecked = sender.titleLabel?.text else { return }
    aloneOrTogether = userChecked
  }
  
  // MARK: - completButtonTapped
  func completButtonTapped(){
    let digit: Double = pow(10, 2)
    let rate = round(cosmosView.rating * digit) / digit
    
    guard let aloneOrTogether = aloneOrTogether,
          let comment = commentTextView.text else { return }
    // 같이 한 경우 해당 유저의 닉네임과 프사도 같이? 혹은 uid?
    if aloneOrTogether == "같이 했어요" {
      guard let userNickname = friendNameLabel.text else { return }
      writeHistoryViewModel.createPost(userNickname, rate, workoutTypes, comment, vc: self)
    } else {
      writeHistoryViewModel.createPost(aloneOrTogether, rate, workoutTypes, comment, vc: self)
    }
  }

  func afterCompleButtonTapped() {
    showPopupViewWithOnebutton("오늘 운동을 기록했어요!")
  }
}

extension WriteHistoryViewController: SelectPersonProtocol {
  func selectPersonProtocol(_ nickname: String) {
    friendNameLabel.text = nickname
  }
}
