//
//  AppFlow+Ext.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/11/25.
//

import UIKit

import RxFlow

/// 가장 최상단 화면 찾기
extension Flow {
   func topMostViewController(
    from rootViewController: UIViewController? = UIApplication.shared.windows.first(
      where: { $0.isKeyWindow })?.rootViewController
  ) -> UIViewController? {
    
      if let presented = rootViewController?.presentedViewController {
        return topMostViewController(from: presented)
      }
      
      if let navigationController = rootViewController as? UINavigationController {
          return topMostViewController(from: navigationController.viewControllers.last)
      }
      
      if let tabBarController = rootViewController as? UITabBarController,
         let selected = tabBarController.selectedViewController {
          return topMostViewController(from: selected)
      }
      
      return rootViewController
  }
}
