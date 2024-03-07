//
//  UIColor+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/01/11.
//

import UIKit

extension UIColor {
  convenience init(hexCode: String, alpha: CGFloat = 1.0) {
    var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if hexFormatted.hasPrefix("#") {
      hexFormatted = String(hexFormatted.dropFirst())
    }
    
    assert(hexFormatted.count == 6, "Invalid hex code used.")
    
    var rgbValue: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
    

  }
//  static let bg20 = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.00)
  static let mainBlue = UIColor(red: 0.23, green: 0.43, blue: 1.00, alpha: 1.00)
  static let kakaoYellow = UIColor(red: 1.00, green: 0.90, blue: 0.00, alpha: 1.00)
  static let naverGreen = UIColor(red: 0.01, green: 0.78, blue: 0.35, alpha: 1.00)
  static let underlineGray = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.00)
  static let unableGray = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
  static let labelBlue = UIColor(red: 0.04, green: 0.15, blue: 0.41, alpha: 1.00)
  static let unableLabelGray = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
  static let stackViewColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
  static let buttonTitleBlue = UIColor(red: 0.21, green: 0.29, blue: 0.46, alpha: 1.00)
  static let searchStackViewColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.00)


}
