
import UIKit

import SnapKit

final class ChatDetailCell: UITableViewCell {

  static let cellId = "ChatDetailCell"
  
  // MARK: - cell 구성
  lazy var myProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  lazy var chatUserProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))

  lazy var userNickNameLabel = UIHelper.shared.createSingleLineLabel("이름이름")
  lazy var chatInfoLabel = UIHelper.shared.createSingleLineLabel("내용내용")
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - view 계층
  func setupLayout(){
    [
      chatUserProfileImageView,
      userNickNameLabel,
      chatInfoLabel,
      myProfileImageView
    ].forEach {
      self.addSubview($0)
    }
  }
  
  // MARK: - layout 설정
  func makeUI(){
    chatUserProfileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(10)
    }
    
    userNickNameLabel.snp.makeConstraints {
      $0.top.equalTo(chatUserProfileImageView.snp.bottom)
      $0.leading.equalTo(chatUserProfileImageView.snp.leading)
    }
    
    chatInfoLabel.backgroundColor = .black
    chatInfoLabel.snp.makeConstraints {
      $0.top.equalTo(chatUserProfileImageView)
      $0.leading.equalTo(chatUserProfileImageView.snp.trailing).offset(10)
    }
      
    myProfileImageView.snp.makeConstraints {
      $0.top.equalTo(chatUserProfileImageView)
      $0.trailing.equalToSuperview().offset(-10)
    }
  
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
