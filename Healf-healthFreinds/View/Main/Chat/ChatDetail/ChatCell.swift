//
//  ChatCell.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/30/24.
//

import UIKit

import SnapKit

class ChatCell: UITableViewCell {
  var model: Model? {
    didSet { bind() }
  }
  
  // MARK: - cell 구성
  var messageLabel = UIHelper.shared.createBasePaddingLabel("",
                                                            backgroundColor: .mainBlue,
                                                            textColor: .black)
  
  var messageTimeLabel = UIHelper.shared.createSingleLineLabel("2024.04.30",
                                                               .lightGray,
                                                               .systemFont(ofSize: 8))
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  // 초기화 어떻게 할지 -> 지금 셀이 계속 늘어나고 줄어들고 난리
  override func prepareForReuse() {
    super.prepareForReuse()
    
    bind()
  }
  
  func setupViews() {
    messageLabel.layer.cornerRadius = 15
    messageLabel.clipsToBounds = true
    messageLabel.numberOfLines = 0
    
    contentView.addSubview(messageLabel)
    messageLabel.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top)
      $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
    }
    
    contentView.addSubview(messageTimeLabel)
  }
  
  func bind() {
    guard let model = model else { return }
    messageLabel.text = model.message
    messageTimeLabel.text = model.timeStamp
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
