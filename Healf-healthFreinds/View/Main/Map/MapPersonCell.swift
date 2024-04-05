
import UIKit

import SnapKit

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
      userProducLabel,
      chatButton
    ].forEach {
      self.addSubview($0)
    }
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
    
    chatButton.snp.makeConstraints {
      $0.centerY.equalTo(userProfileImageView)
      $0.trailing.equalToSuperview().offset(50)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func cellDataSetting(_ userData: UserModel){
    userNickNameLabel.text = userData.nickname
    userProducLabel.text = userData.introduce
  }
}
