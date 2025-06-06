
import UIKit

import SnapKit

final class PostedCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  var delegate: ParticipateButtonDelegate?
  let myPageViewModel = MypageViewModel.shared
  
  var model: CreatePostModel? {
    didSet {
      bind()
    }
  }
  
  private lazy var profileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var nickNameLabel = UIHelper.shared.createSingleLineLabel("닉네임")
  
  private lazy var locationLabel = UIHelper.shared.createBasePaddingLabel("📍송도 1동",
                                                                          backgroundColor: .mainBlue,
                                                                          textColor: .white)
  
  private lazy var workoutTimeLabel = UIHelper.shared.createSingleLineLabel("🕖 평일 18:00 - 21:00",
                                                                            .black,
                                                                            .boldSystemFont(ofSize: 12))
  private lazy var workoutInfoLabel = UIHelper.shared.createSingleLineLabel("🏋🏻 유산소, 하체운동 위주",
                                                                            .black,
                                                                            .boldSystemFont(ofSize: 12))
  private lazy var genderLabel = UIHelper.shared.createSingleLineLabel("🚻 성별 무관",
                                                                       .black,
                                                                       .boldSystemFont(ofSize: 12))

  var settingViewSize: Int = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .white
    
    setViewShadow(backView: self)
    
    addSubviews()
    configure()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addSubviews() {
    [
      profileImageView,
      nickNameLabel,
      locationLabel,
      workoutTimeLabel,
      workoutInfoLabel,
      genderLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  private func configure() {
    settingViewSize = UIScreen.main.isWiderThan375pt ? 56 : 30
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
      $0.width.height.equalTo(settingViewSize)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    settingViewSize = UIScreen.main.isWiderThan375pt ? 10 : 5
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom).offset(settingViewSize)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    workoutTimeLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(20)
      $0.leading.equalTo(profileImageView)
    }
    
    workoutInfoLabel.snp.makeConstraints {
      $0.top.equalTo(workoutTimeLabel.snp.bottom).offset(settingViewSize)
      $0.leading.equalTo(profileImageView)
    }
    
    genderLabel.snp.makeConstraints {
      $0.top.equalTo(workoutInfoLabel.snp.bottom).offset(settingViewSize)
      $0.leading.equalTo(profileImageView)
    }
  }
  
  private func bind() {
    guard let data = model else { return }
    nickNameLabel.text = data.userNickname

    let combinedString = data.workoutTypes.joined(separator: ", ")

    workoutInfoLabel.text = "🏋🏻 운동종류: \(combinedString)"
    workoutTimeLabel.text = "🕖 선호하는 시간: \(data.time)"
    genderLabel.text = "🚻 성별: \(data.gender)"
    locationLabel.text = "📍 \(data.location)"
    
    settingViewSize = UIScreen.main.isWiderThan375pt ? 56 : 30
    myPageViewModel.getUserProfileImage(width: settingViewSize,
                                        hegiht: settingViewSize,
                                        checkMyUid: false,
                                        otherPersonUid: data.userUid) { result in
      self.settingViewSize = UIScreen.main.isWiderThan375pt ? 25 : 10

      self.myPageViewModel.settingProfileImage(profile: self.profileImageView,
                                               result: result,
                                               radious: CGFloat(self.settingViewSize))
    }
  }
}

