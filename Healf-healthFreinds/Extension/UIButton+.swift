//
//  UIButton.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/26.
//

import UIKit

extension UIButton {
  // 밑줄을 생성하는 함수
  private struct AssociatedKeys {
    static var titleLabelKey = "titleLabelKey"
  }
  
  private var underlineView: UIView? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.titleLabelKey) as? UIView
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.titleLabelKey,
                               newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  func setUnderline(_ titleColr: UIColor) {
    guard let title = title(for: .normal) else { return }
    
    // 기존 제목을 숨기고, 새로운 밑줄 뷰를 추가합니다
    setTitle(nil, for: .normal)
    
    underlineView?.removeFromSuperview()
    
    underlineView = UIView()
    underlineView?.backgroundColor = UIColor.black
    
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.textColor = titleColr
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
    }
    
    addSubview(underlineView!)
    underlineView?.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalTo(titleLabel.snp.trailing)
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview().offset(1)
    }
  }
}
