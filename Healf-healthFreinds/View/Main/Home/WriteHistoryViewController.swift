//
//  WritehistoryViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import Cosmos
import SnapKit
import FirebaseFirestoreInternal

final class WriteHistoryViewController: NaviHelper, UITextViewDelegate {
  private lazy var aloneButton = UIHelper.shared.createMethodButton("혼자 했어요")
  private lazy var togetherButton = UIHelper.shared.createMethodButton("같이 했어요")
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
  private lazy var commentTextView: UITextView = {
    let tv = UITextView()
    tv.text = "텍스트를 입력하세요"
    tv.textColor = UIColor.lightGray
    tv.font = UIFont.systemFont(ofSize: 15)
    tv.layer.borderWidth = 0.5
    tv.layer.borderColor = UIColor.lightGray.cgColor
    tv.layer.cornerRadius = 5.0
    tv.adjustUITextViewHeight()
    tv.delegate = self
    return tv
  }()
  
  private lazy var completeButton = UIHelper.shared.createHealfButton("🙌 오늘 운동 끝!", .mainBlue, .white)
  
  let db = Firestore.firestore()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
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
    
    aloneOrTogetherLabel.snp.makeConstraints {
      $0.top.equalTo(selectAloneOrTogetherStackView.snp.bottom).offset(10)
      $0.leading.equalTo(selectAloneOrTogetherStackView)
    }
    
    friendImageView.snp.makeConstraints {
      $0.top.equalTo(aloneOrTogetherLabel.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
      $0.height.equalTo(40)
    }
    
    friendInfoStackView.snp.makeConstraints {
      $0.top.equalTo(friendImageView)
      $0.leading.equalTo(friendImageView.snp.trailing).offset(10)
    }
    
    ratingLabel.snp.makeConstraints {
      $0.top.equalTo(friendInfoStackView.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
    }
    
    cosmosView.rating = 4
    cosmosView.settings.starSize = 40
    
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
    choiceWorkoutStackView.snp.makeConstraints {
      $0.top.equalTo(choiceWorkoutTypeLabel.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
    }
    
    commentLabel.snp.makeConstraints {
      $0.top.equalTo(choiceWorkoutStackView.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
    }
    
    commentTextView.snp.makeConstraints {
      $0.top.equalTo(commentLabel.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(120)
    }
    
    completeButton.addAction(UIAction { _ in
      self.completButtonTapped()
    }, for: .touchUpInside)
    completeButton.snp.makeConstraints {
      $0.top.equalTo(commentTextView.snp.bottom).offset(10)
      $0.leading.equalTo(aloneOrTogetherLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(56)
    }
  }
  
  // MARK: - completButtonTapped
  func completButtonTapped(){
    let myNewDoc = db.collection("users").document()
    myNewDoc.setData(["firstname":"John", "lastname":"Qoo", "age":30, "id": myNewDoc.documentID])
    db.collection("allergies").document(myNewDoc.documentID).setData(["allergies":"peanuts"])

  }
}
