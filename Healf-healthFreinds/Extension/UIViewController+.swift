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

    UIHelper.shared.settingBottomeSheet(bottomSheetVC: postedVC, size: 440.0)

    self.present(postedVC, animated: true, completion: nil)
  }
  
  func showPopupViewWithOnebutton(_ desc: String, checkNavi: Bool = true) {
    let popupVC = PopupViewController(title: "🙌",
                                      desc: desc,
                                      checkCompleteButton: true)
    popupVC.modalPresentationStyle = .overFullScreen
    popupVC.popupView.completButtonAction = { [weak self] in
      self?.dismiss(animated: true) {
        if checkNavi { self?.navigationController?.popViewController(animated: true) }
        else { self?.dismiss(animated: true) }
      }
    }
    self.present(popupVC, animated: false)
  }
}
