//
//  Preview+Ext.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/19/25.
//

import UIKit
import SwiftUI

#if DEBUG
//MARK: ViewController Preview
extension UIViewController {
  private struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
      return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
  }
  
  func toPreview() -> some View {
    Preview(viewController: self)
  }
}
#endif
