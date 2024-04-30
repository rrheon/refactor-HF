//
//  MyChatCell.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/29/24.
//


import UIKit

import SnapKit

final class MyChatCell: ChatCell {
  static let cellId = "MyChatCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 초기화 어떻게 할지 -> 지금 셀이 계속 늘어나고 줄어들고 난리
  override func prepareForReuse() {
    super.prepareForReuse()
  }

  override func setupViews() {
    super.setupViews()
    
    messageTimeLabel.snp.makeConstraints {
      $0.top.equalTo(messageLabel.snp.bottom)
      $0.trailing.equalTo(messageLabel.snp.trailing)
    }
  }
  
  override func bind() {
    super.bind()

    messageLabel.snp.makeConstraints {
      $0.leading.greaterThanOrEqualTo(contentView.snp.leading).offset(65)
      $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
    }

    messageLabel.addTipViewToRightBottom(with: messageLabel.backgroundColor)
  }
}
