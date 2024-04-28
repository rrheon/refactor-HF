//
//  String+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/19/24.
//

import UIKit

extension String {
  func getEstimatedFrame(with font: UIFont) -> CGRect {
    let size = CGSize(width: UIScreen.main.bounds.width * 2/3, height: 1000)
    let optionss = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let estimatedFrame = NSString(string: self).boundingRect(with: size, options: optionss, attributes: [.font: font], context: nil)
    return estimatedFrame
  }
}
