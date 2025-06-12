//
//  AuthTextField.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/10/25.
//

import UIKit

import RxSwift
import RxCocoa

/// AuthTextField
final class AuthTextField: UIView {
  let disposeBag: DisposeBag = DisposeBag()

  // MARK: - UI
  
  let textField: UITextField = UITextField().then {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
  }
  
  let validationLabel: UILabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 12)
    $0.textColor = .red
  }
  
  private lazy var stackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 8
    $0.isLayoutMarginsRelativeArrangement = true
    $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
  }
  
  // MARK: - init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  convenience init(with placeHolder: String) {
    self.init(frame: .zero)
    textField.placeholder = placeHolder
  }
  
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
    
    textField
      .rx.controlEvent(.editingDidBegin)
      .subscribe(onNext: { _ in
        self.textField.layer.borderColor = UIColor.black.cgColor
      })
      .disposed(by: disposeBag)
    
    textField
      .rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: { _ in
        self.textField.layer.borderColor = UIColor.lightGray.cgColor
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Setup
  
  private func setupUI() {
    [textField, validationLabel].forEach {
      stackView.addArrangedSubview($0)
    }
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    validationLabel.isHidden = true
  }
  
  
  /// 유효성 라벨에 메세지 띄우기
  /// - Parameters:
  ///   - message: 띄울 메세지
  ///   - isHidden: 라벨 숨김 여부
  func setValidationMessage(_ message: String, isHidden: Bool) {
    validationLabel.text = message
    validationLabel.isHidden = isHidden
  }
  
  /// TextField secure 처리
  func setSecureTextField(){
    self.textField.isSecureTextEntry = true
  }
}

