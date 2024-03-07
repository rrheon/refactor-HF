
import UIKit

import SnapKit

final class ChatCell: UITableViewCell {

  static let cellId = "ChatCell"
  
  // MARK: - cell 구성
  private lazy var writerProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  lazy var userNickNameLabel = UIHelper.shared.createSingleLineLabel("이름이름")
  private lazy var lastChatInfoLabel = UIHelper.shared.createSingleLineLabel("내용내용")
  private lazy var lastChatTimeLabel = UIHelper.shared.createSingleLineLabel("09:41")
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - view 계층
  func setupLayout(){
    [
      writerProfileImageView,
      userNickNameLabel,
      lastChatInfoLabel,
      lastChatTimeLabel
    ].forEach {
      self.addSubview($0)
    }
  }
  
  // MARK: - layout 설정
  func makeUI(){
    writerProfileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(10)
    }
    
    userNickNameLabel.snp.makeConstraints {
      $0.top.equalTo(writerProfileImageView)
      $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
    }
    
    lastChatInfoLabel.snp.makeConstraints {
      $0.top.equalTo(userNickNameLabel.snp.bottom).offset(5)
      $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
    }
    
    lastChatTimeLabel.snp.makeConstraints {
      $0.centerY.equalTo(writerProfileImageView)
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
