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
  
  func addTipViewToLeftTop(with color: UIColor?) {
    
    let path = CGMutablePath()
    path.move(to: CGPoint(x: -8, y: 16))
    path.addLine(to: CGPoint(x: 12, y: 16))
//    path.addLine(to: CGPoint(x: 12, y: 2))
    
    let shape = CAShapeLayer()
    shape.path = path
    shape.fillColor = color?.cgColor
    layer.insertSublayer(shape, at: 0)
  }
  
  func addTipViewToRightBottom(with color: UIColor?) {
    // frame 값을 얻기 위해서 layoutIfNeeded() 호출 (호출 안하면 width, height값 모두 0인 상태)
    layoutIfNeeded()
    
    print(frame)
    
    let height = frame.height
    let width = frame.width
    
    let path = CGMutablePath()
    path.move(to: CGPoint(x: width + 12, y: height - 18))
    path.addLine(to: CGPoint(x: width - 8, y: height - 18))
//    path.addLine(to: CGPoint(x: width - 8, y: height - 4))
    
    let shape = CAShapeLayer()
    shape.path = path
    shape.fillColor = color?.cgColor
    layer.insertSublayer(shape, at: 0)
  }
}
