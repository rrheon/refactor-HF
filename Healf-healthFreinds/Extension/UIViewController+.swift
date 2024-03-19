//
//  UIViewController+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/17/24.
//

import UIKit

extension UIViewController {
  
// MARK: - 운동종류 선택하는 버튼누를 때
  func workoutTypeButtonTapped(_ sender: UIButton,
                               completion: @escaping (([String]) -> Void)) {
    guard let workout = sender.titleLabel?.text else { return }
    var workouts: [String] = []
    
    if sender.currentImage == UIImage(named: "CheckboxImg") {
      sender.setImage(UIImage(named: "EmptyCheckboxImg"), for: .normal)
//      workoutTypes.removeAll { $0 == workout }
      workouts.removeAll { $0 == workout }
    } else {
      sender.setImage(UIImage(named: "CheckboxImg"), for: .normal)
//      workoutTypes.append(workout)
      workouts.append(workout)
    }
    completion(workouts)
  }
  
  // MARK: - cell 눌렀을 때 bottomsheet로 표시
  func moveToPostedVC(_ userData: CreatePostModel) {
    let postedVC = PostedViewController()
    postedVC.configure(with: userData)

    if #available(iOS 15.0, *) {
      if let sheet = postedVC.sheetPresentationController {
        if #available(iOS 16.0, *) {
          sheet.detents = [.custom(resolver: { context in
            return 400.0
          })]
        } else {
          // Fallback on earlier versions
        }
        sheet.largestUndimmedDetentIdentifier = nil
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersEdgeAttachedInCompactHeight = true
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheet.preferredCornerRadius = 20
      }
    } else {
    }
    self.present(postedVC, animated: true, completion: nil)
  }
}
