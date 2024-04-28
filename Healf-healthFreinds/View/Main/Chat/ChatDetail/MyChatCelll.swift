
import UIKit

import SnapKit

final class ChatDetailCell: UITableViewCell {
  var model: Model? {
    didSet { bind() }
  }
  
  static let cellId = "ChatDetailCell"
  
  // MARK: - cell 구성
  
  let messageTextView: UITextView = {
    let view = UITextView()
    view.font = .systemFont(ofSize: 18.0)
    view.text = "Sample message"
    view.textColor = .black
    view.backgroundColor = .white
    view.layer.cornerRadius = 15.0
    view.layer.masksToBounds = false
    view.isEditable = false
    return view
  }()
  
  let profileImageView: UIImageView = {
    let view = UIImageView(image: UIImage(named: "EmptyProfileImg"))
    view.layer.cornerRadius = view.bounds.width / 2
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.clear.cgColor
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    //    setupLayout()
    //    makeUI()
    setupViews()
  }
//  
//  // 초기화 어떻게 할지 -> 지금 셀이 계속 늘어나고 줄어들고 난리
//  override func prepareForReuse() {
//    super.prepareForReuse()
//    messageTextView.snp.removeConstraints()
//    setupViews()
//    bind()
//  }
  
  func setupViews() {
    contentView.addSubview(messageTextView)
    messageTextView.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top)
      $0.bottom.equalTo(contentView.snp.bottom)
    }
    
    contentView.addSubview(profileImageView)
    profileImageView.snp.makeConstraints {
      $0.leading.equalTo(contentView.snp.leading).offset(8)
    }
  }
  
  private func bind() {
    guard let model = model, let font = messageTextView.font else { return }
    messageTextView.text = model.message
    let estimatedFrame = model.message.getEstimatedFrame(with: font)
    
    messageTextView.widthAnchor.constraint(equalToConstant: estimatedFrame.width + 16).isActive = true
    
    if case .send = model.chatType {
      messageTextView.backgroundColor = .mainBlue
      profileImageView.isHidden = true
      messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
      messageTextView.addTipViewToRightBottom(with: messageTextView.backgroundColor)
    } else {
      messageTextView.backgroundColor = .lightGray
      profileImageView.isHidden = false
      messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 16 + profileImageView.bounds.width).isActive = true
      messageTextView.addTipViewToLeftTop(with: messageTextView.backgroundColor)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
