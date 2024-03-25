
import UIKit

import SnapKit

final class PostedViewController: UIViewController {
  private lazy var timeTitleLabel = UIHelper.shared.createSingleLineLabel("시간대 ⏰")
  private lazy var postedTimeLabel = UIHelper.shared.createSingleLineLabel("08:00~10:00")
  private lazy var timeStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 8)
  
  // 운동종류
  private lazy var workoutTitleLabel = UIHelper.shared.createSingleLineLabel("운동 종류 🏋🏻")
  private lazy var workoutInfoLabel = UIHelper.shared.createSingleLineLabel("유산소")
  private lazy var workoutStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 8)
  
  // 성별 관련
  private lazy var genderLabel = UIHelper.shared.createSingleLineLabel("성별 🚻")
  private lazy var fixedGenderLabel = UIHelper.shared.createSingleLineLabel("무관")
  private lazy var genderStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 8)
  
  private lazy var workoutInfoStackView = UIHelper.shared.createStackView(axis: .horizontal, spacing: 10)
    
  private lazy var produceLabel = UIHelper.shared.createMultipleLineLabel("소개\n운동할 사람 모집합니다.")
  
  // 작성자 정보
  private lazy var writerProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var writerNickNameLabel = UIHelper.shared.createSingleLineLabel("닉네임")
  
  private lazy var participateButton = UIHelper.shared.createHealfButton("메시지 보내기 ✉️", .mainBlue, .white)
    
  var destinationUid: String?
  let chatDetailViewModel = ChatDetailViewModel.shared
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.backgroundColor = .white
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      timeTitleLabel,
      postedTimeLabel
    ].forEach {
      timeStackView.addArrangedSubview($0)
    }
    
    [
      workoutTitleLabel,
      workoutInfoLabel
    ].forEach {
      workoutStackView.addArrangedSubview($0)
    }
    
    [
      genderLabel,
      fixedGenderLabel
    ].forEach {
      genderStackView.addArrangedSubview($0)
    }
    
    [
      timeStackView,
      workoutStackView,
      genderStackView
    ].forEach {
      workoutInfoStackView.addArrangedSubview($0)
      $0.alignment = .center
    }
    
    [
      workoutInfoStackView,
      produceLabel,
      writerProfileImageView,
      writerNickNameLabel,
      participateButton
    ].forEach {
      view.addSubview($0)
    }
    
  }
  
  // MARK: - makeUI
  func makeUI(){
    workoutInfoStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(50)
      $0.leading.trailing.equalToSuperview()
    }
    
    workoutInfoStackView.distribution = .fillEqually
    
    [
      timeStackView,
      workoutStackView,
      genderStackView,
      workoutInfoStackView
    ].forEach {
      $0.backgroundColor = UIColor.init(hexCode: "#F6F6F6")
    }
    
    produceLabel.textAlignment = .left
    produceLabel.snp.makeConstraints {
      $0.top.equalTo(workoutInfoStackView.snp.bottom).offset(30)
      $0.leading.equalToSuperview().offset(20)
    }
  
    writerProfileImageView.snp.makeConstraints {
      $0.bottom.equalTo(view.snp.bottom).offset(-50)
      $0.leading.equalTo(produceLabel)
    }
    
    writerNickNameLabel.snp.makeConstraints {
      $0.top.equalTo(writerProfileImageView.snp.top).offset(10)
      $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
    }
    
    participateButton.addAction(UIAction { _ in
      self.participateButtonTapped()
    }, for: .touchUpInside)
    participateButton.snp.makeConstraints {
      $0.top.equalTo(writerProfileImageView)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(41)
      $0.width.equalTo(151)
    }
  }
  
  func participateButtonTapped(){
    chatDetailViewModel.createRoom(destinationUid ?? "") {
      self.showPopupViewWithOnebutton("채팅방이 생성되었습니다!", checkNavi: false)
    }
  }
}

extension PostedViewController: postedDataConfigurable {
  func configure(with data: CreatePostModel) {
    postedTimeLabel.text = data.time
    workoutInfoLabel.text = data.workoutTypes.joined(separator: ", ")
    fixedGenderLabel.text = data.gender
    produceLabel.text = data.info
    writerNickNameLabel.text = data.userNickname
    
    destinationUid = data.userUid
  }
}
