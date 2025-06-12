
import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

/// 팝업View의 Delegate
/// - 버튼 액션
protocol PopupViewDelegate: AnyObject {
  func leftBtnTapped(dismissAction: () -> ())
  func rightBtnTapped(dismissAction: () -> ())
  func endBtnTapped(dismissAction: () -> ())
}

extension PopupViewDelegate {
  func leftBtnTapped(dismissAction: () -> ()) {
    dismissAction()
  }
  
  func rightBtnTapped(dismissAction: () -> ()) {
    dismissAction()
  }
  
  func endBtnTapped(dismissAction: () -> ()) {
    dismissAction()
  }
}


/// 팝업 View
final class PopupView: UIView {
  
  private let popupType: PopupCase
  
  weak var delegate: PopupViewDelegate?
  
  var dismissAction: (() -> ())? = nil
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let popupView: UIView = UIView().then {
    $0.layer.cornerRadius = 7
    $0.clipsToBounds = true
    $0.backgroundColor = .white
  }
  
  private let titleLabel: UILabel = UILabel().then {
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  private let descLabel: UILabel = UILabel().then {
    $0.font = UIFont(name: "Pretendard-Medimu", size: 14)
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  private let leftButton: UIButton = UIButton().then {
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .unableGray
    $0.titleLabel?.font = UIFont(name: "Pretendard-Medimu", size: 16)
    $0.layer.cornerRadius = 8
  }
  
  private let rightButton: UIButton = UIButton().then {
    $0.backgroundColor = .mainBlue
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-Medimu", size: 16)
    $0.layer.cornerRadius = 8
  }
  
  private let completeButton: UIButton = UIButton().then {
    $0.backgroundColor = .mainBlue
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-Medimu", size: 16)
    $0.layer.cornerRadius = 8
  }
  
  private lazy var buttonStack: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 10
    $0.distribution = .fillEqually
  }
  
  init(with type: PopupCase) {
    self.popupType = type
    
    super.init(frame: .zero)
    
    self.backgroundColor = .clear
    
    self.setupConstraints()
    self.setupUI()
    
    self.action()
  
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.addSubview(self.popupView)

    if popupType.popupData.isEndBtn {
      self.buttonStack.addArrangedSubview(self.completeButton)
    } else {
      self.buttonStack.addArrangedSubview(self.leftButton)
      self.buttonStack.addArrangedSubview(self.rightButton)
    }
    
    self.popupView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.8)
    }
    
    self.popupView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(popupView.snp.top).offset(35)
      make.left.right.equalToSuperview().inset(24)
    }
    
    self.popupView.addSubview(self.descLabel)
    self.descLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.left.right.equalToSuperview().inset(24)
    }

    
    self.popupView.addSubview(self.buttonStack)
    buttonStack.snp.makeConstraints { make in
      make.top.equalTo(descLabel.snp.bottom).offset(30)
      make.left.equalTo(popupView).offset(10)
      make.right.equalTo(popupView).offset(-10)
      make.bottom.equalTo(popupView).offset(-15)
      
      if popupType.popupData.isEndBtn {
        make.height.equalTo(47)
      }
    }
    
    
    if popupType.popupData.isEndBtn == false {
      leftButton.snp.makeConstraints { make in
        make.height.equalTo(47)
        make.width.equalTo(rightButton) // 좌우 버튼의 크기를 같게 설정
      }
      
      rightButton.snp.makeConstraints { make in
        make.height.equalTo(47)
      }
    }
  }
  
  
  /// PopupView UI 설정
  private func setupUI(){
    self.titleLabel.text = popupType.popupData.title
    self.descLabel.text = popupType.popupData.description
    self.leftButton.setTitle(popupType.popupData.leftBtnTitle, for: .normal)
    self.rightButton.setTitle(popupType.popupData.rightBtnTitle, for: .normal)
    self.completeButton.setTitle("확인", for: .normal)
  }
  
  
  /// Popupview 버튼 action
  private func action(){
    leftButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (view, _) in
        self.delegate?.leftBtnTapped(dismissAction: {
          view.dismissAction?()
        })
      })
      .disposed(by: disposeBag)
    
    rightButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (view, _) in
        self.delegate?.rightBtnTapped(dismissAction: {
          view.dismissAction?()
        })
      })
      .disposed(by: disposeBag )
    
    completeButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (view, _) in
        self.delegate?.endBtnTapped(dismissAction: {
          view.dismissAction?()
        })
      })
      .disposed(by: disposeBag)
  }
}
