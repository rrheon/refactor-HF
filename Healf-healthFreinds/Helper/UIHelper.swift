//
//  UIHelper.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/26.
//

import UIKit

final class UIHelper {
  static let shared = UIHelper()
  
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
  func createBasePaddingLabel(_ title: String) -> UILabel{
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
    label.text = title
    label.layer.cornerRadius = 5
    label.font = .boldSystemFont(ofSize: 12)
    label.clipsToBounds = true
    label.backgroundColor = .mainBlue
    label.textColor = .white
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
  
  // MARK: - 운동(혼자 or 같이) 버튼 만들기
  func createMethodButton(_ title: String) -> UIButton {
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
  func createButtonWithImage(_ title: String = "", _ image: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.setImage(UIImage(named: image), for: .normal)
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

}
