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
    let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    let estimatedFrame = NSString(string: self).boundingRect(with: size,
                                                             options: options,
                                                             attributes: attributes,
                                                             context: nil)
    return estimatedFrame
  }
}
