//
//  UIView+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2/29/24.
//

import UIKit

extension UIView {
  // colloectionview 테두리 그림자설정
  func setViewShadow(backView: UIView) {
    backView.layer.masksToBounds = true
    backView.layer.cornerRadius = 10
    
    layer.masksToBounds = false
    
    backView.layer.shadowOpacity = 0.1
    backView.layer.shadowOffset = CGSize(width: 0, height: 10)
    backView.layer.shadowRadius = 4
    backView.layer.shadowColor = UIColor.cellShadow.cgColor
    
    // Set the shadow path for the view
    backView.layer.shadowPath = UIBezierPath(roundedRect: backView.bounds, cornerRadius: backView.layer.cornerRadius).cgPath
  }
  
}
