
import UIKit

import SnapKit

protocol MapPersonCellButton: AnyObject {
  func chatButtonTapped(destinationUid: String)
}

final class MapPersonCell: UITableViewCell {

  static let cellId = "MapPersonCell"
  
  // MARK: - cell 구성
  private lazy var userProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var userNickNameLabel = UIHelper.shared.createSingleLineLabel("유저이름",
                                                                             .black,
                                                                             .systemFont(ofSize: 13))
  private lazy var userProducLabel = UIHelper.shared.createSingleLineLabel("소개내용",
                                                                           .unableGray,
                                                                           .systemFont(ofSize: 10))
  private lazy var chatButton = UIHelper.shared.createButtonWithImage("", "ChatButtonImg")
  
  weak var delegate: MapPersonCellButton?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - view 계층
  func setupLayout(){
    [
      userProfileImageView,
      userNickNameLabel,
      userProducLabel
    ].forEach {
      self.addSubview($0)
    }
    self.contentView.addSubview(chatButton)
  }
  
  // MARK: - layout 설정
  func makeUI(){
    userProfileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(10)
      $0.height.width.equalTo(40)
    }
    
    userNickNameLabel.snp.makeConstraints {
      $0.top.equalTo(userProfileImageView).offset(5)
      $0.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
    }
    
    userProducLabel.snp.makeConstraints {
      $0.top.equalTo(userNickNameLabel.snp.bottom).offset(5)
      $0.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
    }
  
    chatButton.isExclusiveTouch = false // 버튼이 터치 이벤트를 가로채지 않음
    chatButton.snp.makeConstraints {
      $0.centerY.equalTo(userProfileImageView)
      $0.trailing.equalToSuperview().offset(50)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func cellDataSetting(_ userData: UserModel){
    chatButton.addAction(UIAction { _ in
      print("1")
      self.delegate?.chatButtonTapped(destinationUid: userData.uid ?? "")
    }, for: .touchUpInside)
    
    userNickNameLabel.text = userData.nickname
    userProducLabel.text = userData.introduce
    
    MypageViewModel.shared.getUserProfileImage(checkMyUid: false,
                                               otherPersonUid: userData.uid ?? "") { result in
      MypageViewModel.shared.settingProfileImage(profile: self.userProfileImageView,
                                               result: result,
                                               radious: 15)
    }
  }
}
