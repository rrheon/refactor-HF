
import UIKit

import SnapKit

class DestinationChatCelll: ChatCell  {
  static let cellId = "DestinationChatCell"

  let profileImageView: UIImageView = {
    let view = UIImageView(image: UIImage(named: "EmptyProfileImg"))
    view.layer.cornerRadius = view.bounds.width / 2
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.clear.cgColor
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupViews() {
    super.setupViews()

    contentView.addSubview(profileImageView)
    profileImageView.snp.makeConstraints {
      $0.leading.equalTo(contentView.snp.leading).offset(8)
      $0.width.equalTo(40)
    }
    
    messageTimeLabel.snp.makeConstraints {
      $0.top.equalTo(messageLabel.snp.bottom)
      $0.leading.equalTo(messageLabel.snp.leading)
    }
  }
  
  override func bind() {
    super.bind()
    
    messageLabel.backgroundColor = .lightGray
    messageLabel.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
      $0.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-65)
    }
    
    messageLabel.addTipViewToLeftTop(with: messageLabel.backgroundColor)
  }
}
