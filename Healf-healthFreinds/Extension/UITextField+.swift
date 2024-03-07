//
//  TextField+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/05.
//

import UIKit

import SnapKit

extension UITextField {
  // MARK: - 밑줄 생성
  func addBottomLine(withColor color: UIColor, height: CGFloat) {
    let bottomLine = UIView()
    bottomLine.backgroundColor = color
    self.borderStyle = .none
    
    addSubview(bottomLine)
    
    bottomLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(10)
      $0.height.equalTo(height)
    }
  }
}
