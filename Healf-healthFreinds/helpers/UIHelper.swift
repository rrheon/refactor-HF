//
//  UIHelper.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/26.
//

import UIKit

import RxSwift

final class UIHelper: UIViewController {
  static let shared = UIHelper()
  var disposeBag: DisposeBag = .init()

  // MARK: - 라벨 한 줄
  func createSingleLineLabel(_ title: String,
                   _ color: UIColor = .black,
                   _ font: UIFont = .boldSystemFont(ofSize: 14)) -> UILabel {
    let label = UILabel()
    label.text = title
    label.textColor = color
    label.font = font
    return label
  }
  
  // MARK: - 라벨 여러 줄
  func createMultipleLineLabel(_ title: String,
                               _ color: UIColor = .black,
                               _ font: UIFont = .boldSystemFont(ofSize: 14),
                               _ textAlignment: NSTextAlignment = .center) -> UILabel {
    let label = UILabel()
    label.text = title
    label.textColor = color
    label.font = font
    label.numberOfLines = 0
    label.setLineSpacing(spacing: 10)
    label.textAlignment = textAlignment
    return label
  }
  
  // MARK: - 여백있는 라벨 만들기
  func createBasePaddingLabel(_ title: String, backgroundColor: UIColor, textColor: UIColor) -> UILabel{
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
    label.text = title
    label.layer.cornerRadius = 5
    label.font = .boldSystemFont(ofSize: 12)
    label.clipsToBounds = true
    label.backgroundColor = backgroundColor
    label.textColor = textColor
    return label
  }
 
  // MARK: - 주간 달성 라벨 만들기
  func createWeeklyCompleteLabel(_ title: String) -> UILabel{
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.text = title
    label.textColor = .white
    label.textAlignment = .center
    label.backgroundColor = .unableLabelGray
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    return label
  }
  
  // MARK: - healf버튼 생성
  func createHealfButton(_ title: String,
                         _ color: UIColor,
                         _ titleColor: UIColor) -> UIButton {
   let button = UIButton()
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.setTitleColor(titleColor, for: .normal)
    button.backgroundColor = color
    button.layer.cornerRadius = 10  
    return button
  }
  
  // MARK: - 선택버튼 만들기
  func createSelectButton(_ title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor(hexCode: "#A1AAB0"), for: .normal)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hexCode: "#D8DCDE").cgColor
    button.layer.cornerRadius = 5
    button.backgroundColor = .white
    return button
  }
  
  // MARK: - 체크버튼 만들기
  func createButtonWithImage(_ title: String = "",
                             _ image: String,
                             checkButton: Bool = true) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.setImage(UIImage(named: image), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    button.contentHorizontalAlignment = .leading
    button.widthAnchor.constraint(equalToConstant: 100).isActive = checkButton
    return button
  }
  
  // MARK: - 일반 버튼
  func createProfileButton(title: String, color: UIColor, action: Selector) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(color, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 12)
    button.addTarget(self, action: action, for: .touchUpInside)
    return button
  }

  // MARK: - 로그인 textfield
  func createLoginTextField(_ placeHolder: String) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeHolder
    textField.font = .systemFont(ofSize: 15)
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.addBottomLine(withColor: .underlineGray, height: 1)
    return textField
  }
  
  // MARK: - textfield
  func createGeneralTextField(_ placeHolder: String) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeHolder
    textField.font = .systemFont(ofSize: 15)
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.black.cgColor
    return textField
  }
  
  // MARK: - textView만들기
  func createGeneralTextView(_ placeHolder: String) -> UITextView {
    let textView = UITextView()
    textView.text = placeHolder
    textView.textColor = UIColor.lightGray
    textView.font = UIFont.systemFont(ofSize: 15)
    textView.layer.borderWidth = 0.5
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.cornerRadius = 5.0
    textView.adjustUITextViewHeight()
    return textView
  }
  
  // MARK: - 스택뷰 만들기
  func createStackView(axis: NSLayoutConstraint.Axis,
                       spacing: CGFloat,
                       backgroundColor: UIColor = .stackViewColor) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.spacing = spacing
    stackView.layer.cornerRadius = 5
    stackView.clipsToBounds = true
    stackView.backgroundColor = backgroundColor
    stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    stackView.isLayoutMarginsRelativeArrangement = true
    return stackView
  }
  
  func createCollectionView(scrollDirection: UICollectionView.ScrollDirection,
                            spacing: CGFloat) -> UICollectionView {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = scrollDirection
    flowLayout.minimumLineSpacing = spacing
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    
    return view
  }
  
  // MARK: - 글자색상 일부분 변경
  func changeColor(label: UILabel,
                   wantToChange: String,
                   color: UIColor,
                   font: UIFont? = nil,
                   lineSpacing: CGFloat? = nil) {
    guard let originalText = label.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
    
    let range = (originalText.string as NSString).range(of: wantToChange)
    originalText.addAttribute(.foregroundColor, value: color, range: range)
    
    if let font = font {
      originalText.addAttribute(.font, value: font, range: range)
    }
    
    if let lineSpacing = lineSpacing {
      let style = NSMutableParagraphStyle()
      style.lineSpacing = lineSpacing
      originalText.addAttribute(.paragraphStyle, 
                                value: style,
                                range: NSRange(location: 0, length: originalText.length))
    }
    
    label.attributedText = originalText
  }

  // MARK: - bottomSheet
  func settingBottomeSheet(bottomSheetVC: UIViewController, size: Double){
    if #available(iOS 15.0, *) {
      if let sheet = bottomSheetVC.sheetPresentationController {
        if #available(iOS 16.0, *) {
          sheet.detents = [.custom(resolver: { context in
            return size
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
      // Fallback on earlier versions
    }
  }
  
  // MARK: - toast message, 이미지가 뒤에 나오고 있음 앞으로 빼기, 이미지 없을 때도 있음
  func showToast(message: String) {
    let toastContainer = UIView()
    toastContainer.backgroundColor = .lightGray
    toastContainer.layer.cornerRadius = 10
    
    let toastLabel = UILabel()
    toastLabel.textColor = .black
    toastLabel.font = UIFont(name: "Pretendard", size: 14)
    toastLabel.text = message
    toastLabel.textAlignment = .center
    toastLabel.numberOfLines = 0
    
    toastContainer.addSubview(toastLabel)
  
    guard let keyWindow = UIApplication.shared.keyWindow else { return }
    
    keyWindow.addSubview(toastContainer)
    
    toastContainer.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(keyWindow.safeAreaLayoutGuide.snp.bottom).offset(-50)
      make.width.equalTo(335)
      make.height.equalTo(56)
    }

    toastLabel.snp.makeConstraints { make in
      make.centerY.equalTo(toastContainer)
      make.leading.equalTo(toastContainer).offset(30)
      make.trailing.equalTo(toastContainer).offset(-16)
    }
    
    UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
      toastContainer.alpha = 0.0
    }, completion: { _ in
      toastContainer.removeFromSuperview()
    })
  }
  
  func createChatRoom(destinationUid: String, vc: UIViewController, checkNavi: Bool = false){
    ChatDetailViewModel.shared.checkMessageOption(destinationUid: destinationUid) { result in
      if result == "true" {
        vc.showPopupViewWithOnebuttonAndDisappearVC("채팅이 불가능합니다!", checkNavi: checkNavi)
        return
      } else {
        ChatDetailViewModel.shared.createRoom(destinationUid) { result in
          switch result{
          case true:
            vc.showPopupViewWithOnebuttonAndDisappearVC("채팅방이 생성되었습니다!", checkNavi: checkNavi)
          case false:
            vc.showPopupViewWithOnebuttonAndDisappearVC("채팅이 불가능합니다!", checkNavi: checkNavi)
          }
        }
      }
    }
  }
}
