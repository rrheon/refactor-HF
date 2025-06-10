//
//  TextField+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/05.
//

import UIKit

import SnapKit

extension UITextField {
  
  /// TextField 밑줄 생성
  /// - Parameters:
  ///   - color: 밑줄의 색상
  ///   - height: 밑줄의 두께
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
  
  func addLeftPadding(){
    self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
    self.leftViewMode = .always
  }
}
