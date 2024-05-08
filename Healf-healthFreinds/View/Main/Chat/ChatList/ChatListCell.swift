
import UIKit

import SnapKit

struct ChatListCellModel {
  let uid: String
  let nickname: String
  let lastMessage: String
  let timeStamp: String
}

final class ChatListCell: UITableViewCell {

  static let cellId = "ChatCell"
  let myPageViewModel = MypageViewModel.shared
  
  var model: ChatListCellModel?{
    didSet{
      bind()
    }
  }
  
  // MARK: - cell 구성
  private lazy var writerProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  lazy var userNickNameLabel = UIHelper.shared.createSingleLineLabel("이름이름")
  lazy var lastChatInfoLabel = UIHelper.shared.createSingleLineLabel("내용내용")
  lazy var lastChatTimeLabel = UIHelper.shared.createSingleLineLabel("09:41")
  
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
    
    lastChatInfoLabel.textColor = .lightGray
    lastChatInfoLabel.snp.makeConstraints {
      $0.top.equalTo(userNickNameLabel.snp.bottom).offset(10)
      $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
    }
    
    lastChatTimeLabel.textColor = .lightGray
    lastChatTimeLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(){
//    writerProfileImageView.image = model?.profile
    guard let model = model else { return }
    userNickNameLabel.text = model.nickname
    lastChatInfoLabel.text = model.lastMessage
    lastChatTimeLabel.text = model.timeStamp
    
    myPageViewModel.getUserProfileImage(checkMyUid: false,
                                        otherPersonUid: model.uid) { result in
      self.myPageViewModel.settingProfileImage(profile: self.writerProfileImageView,
                                               result: result,
                                               radious: 25)
    }

  }
}
