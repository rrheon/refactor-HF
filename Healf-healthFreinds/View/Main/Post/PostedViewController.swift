
import UIKit

import SnapKit

final class PostedViewController: NaviHelper {

  // 작성일, 위치, 제목
  private lazy var postedDateLabel = UIHelper.shared.createSingleLineLabel("2024-03-02")
  private lazy var postedLocationLabel = UIHelper.shared.createSingleLineLabel("인천 송도")
  private lazy var postedTitleLabel = UIHelper.shared.createSingleLineLabel("운동 같이해요~",
                                                                            .black, .boldSystemFont(ofSize: 20))
  // 인원수 관련
  private lazy var memberNumberLabel = UIHelper.shared.createSingleLineLabel("인원수")
  private lazy var memberImageView = UIImageView(image: UIImage(named: "PersonImg"))
  private lazy var memeberNumberCountLabel = UIHelper.shared.createSingleLineLabel("1/2명")
  private lazy var memberNumberStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 8)
  
  // 운동종류
  private lazy var workoutTitleLabel = UIHelper.shared.createSingleLineLabel("운동종류")
  private lazy var workoutImageView = UIImageView(image: UIImage(named: "PersonImg"))
  private lazy var workoutInfoLabel = UIHelper.shared.createSingleLineLabel("유산소")
  private lazy var workoutStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 8)
  
  // 성별 관련
  private lazy var genderLabel = UIHelper.shared.createSingleLineLabel("성별")
  private lazy var genderImageView = UIImageView(image: UIImage(named: "GenderMixImg"))
  private lazy var fixedGenderLabel = UIHelper.shared.createSingleLineLabel("무관")
  private lazy var genderStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 8)
  private lazy var workoutInfoStackView = UIHelper.shared.createStackView(axis: .horizontal, spacing: 10)
  private lazy var totlaWorkoutInfoStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 10)
  
  private lazy var produceLabel = UIHelper.shared.createMultipleLineLabel("소개\n운동할 사람 모집합니다.")
  
  // 작성자 정보
  private lazy var writerLabel = UIHelper.shared.createSingleLineLabel("작성자")
  private lazy var writerProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var writerNickNameLabel = UIHelper.shared.createSingleLineLabel("닉네임")
  
  private lazy var participateButton = UIHelper.shared.createHealfButton("참여하기", .mainBlue, .white)
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItemSetting()
    
    view.backgroundColor = .white
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    
    [
      memberNumberLabel,
      memberImageView,
      memeberNumberCountLabel
    ].forEach {
      memberNumberStackView.addArrangedSubview($0)
    }
    
    [
      workoutTitleLabel,
      workoutImageView,
      workoutInfoLabel
    ].forEach {
      workoutStackView.addArrangedSubview($0)
    }
    
    [
      genderLabel,
      genderImageView,
      fixedGenderLabel
    ].forEach {
      genderStackView.addArrangedSubview($0)
    }
    
    [
      memberNumberStackView,
      workoutStackView,
      genderStackView
    ].forEach {
      workoutInfoStackView.addArrangedSubview($0)
      $0.alignment = .center
    }
    
    [
     postedDateLabel,
     postedLocationLabel,
     postedTitleLabel,
     workoutInfoStackView
    ].forEach {
      totlaWorkoutInfoStackView.addArrangedSubview($0)
    }
    
    
    [
      totlaWorkoutInfoStackView,
      produceLabel,
      writerLabel,
      writerProfileImageView,
      writerNickNameLabel,
      participateButton
    ].forEach {
      view.addSubview($0)
    }
    
  }
  
  // MARK: - makeUI
  func makeUI(){
    totlaWorkoutInfoStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(50)
      $0.leading.trailing.equalToSuperview()
    }
    
    workoutInfoStackView.distribution = .fillProportionally
    [
      memberNumberStackView,
      workoutStackView,
      genderStackView,
      workoutInfoStackView
    ].forEach {
      $0.backgroundColor = .gray
    }
    
    produceLabel.textAlignment = .left
    produceLabel.snp.makeConstraints {
      $0.top.equalTo(workoutInfoStackView.snp.bottom).offset(30)
      $0.leading.equalTo(postedDateLabel)
    }
    
    writerLabel.snp.makeConstraints {
      $0.top.equalTo(view.snp.bottom).offset(-200)
      $0.leading.equalTo(postedDateLabel)
    }
    
    writerProfileImageView.snp.makeConstraints {
      $0.top.equalTo(writerLabel.snp.bottom).offset(20)
      $0.leading.equalTo(postedDateLabel)
    }
    
    writerNickNameLabel.snp.makeConstraints {
      $0.top.equalTo(writerProfileImageView.snp.centerY)
      $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
    }
    
    participateButton.snp.makeConstraints {
      $0.top.equalTo(writerProfileImageView.snp.bottom).offset(30)
      $0.leading.equalTo(postedDateLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(48)
    }
  }
}
