//
//  UIViewController+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/17/24.
//

import UIKit

extension UIViewController: UITextViewDelegate {
  
// MARK: - 운동종류 선택하는 버튼누를 때
  func workoutTypeButtonTapped(_ sender: UIButton, completion: @escaping (([String]) -> Void)) {
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
  
  func showPopupViewWithOnebuttonAndDisappearVC(_ desc: String, checkNavi: Bool = true) {
//    let popupVC = PopupViewController(title: "🙌",
//                                      desc: desc,
//                                      checkCompleteButton: true)
//    popupVC.modalPresentationStyle = .overFullScreen
//    popupVC.popupView.completButtonAction = { [weak self] in
//      self?.dismiss(animated: true) {
//        if checkNavi { self?.navigationController?.popViewController(animated: true) }
//        else { self?.dismiss(animated: true) }
//      }
//    }
//    self.present(popupVC, animated: false)
  }
  
  func showPopupViewWithOneButton(_ desc: String, checkNavi: Bool = true){
//    let popupVC = PopupViewController(title: "🚨",
//                                      desc: desc,
//                                      checkCompleteButton: true)
//    popupVC.modalPresentationStyle = .overFullScreen
//    popupVC.popupView.completButtonAction = { [weak self] in
//      self?.dismiss(animated: true)
//    }
//    self.present(popupVC, animated: false)

  }
  
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  func setupKeyboardEvent() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  @objc func keyboardWillShow(_ sender: Notification) {
    // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
    guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardHeight = keyboardFrame.cgRectValue.height
    
    // ⭐️ 이 조건을 넣어주지 않으면, 각각의 텍스트필드마다 keyboardWillShow 동작이 실행되므로 아래와 같은 현상이 발생
    if view.frame.origin.y == 0 {
      view.frame.origin.y -= keyboardHeight
    }
  }
  
  @objc func keyboardWillHide(_ sender: Notification) {
    if view.frame.origin.y != 0 {
      view.frame.origin.y = 0
    }
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "내용을 입력하세요." {
      textView.text = nil
      textView.textColor = .black
    }
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      textView.text = "내용을 입력하세요."
      textView.textColor = .lightGray
    }
  }
}
