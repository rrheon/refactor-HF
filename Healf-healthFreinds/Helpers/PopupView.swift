

import UIKit

import SnapKit

final class PopupView: UIView {
  var leftButtonAction: (() -> Void)?
  var rightButtonAction: (() -> Void)?
  var completButtonAction: (() -> Void)?
  var checkComplete = false
  
  private let popupView: UIView = {
    let view = UIView()

    view.layer.cornerRadius = 7
    view.clipsToBounds = true
    view.backgroundColor = .white
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let descLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard-Medimu", size: 14)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = .black
    
    return label
  }()
  
  private let leftButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .unableGray
    button.titleLabel?.font = UIFont(name: "Pretendard-Medimu", size: 16)
    button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    button.layer.cornerRadius = 8
    return button
  }()
  
  private let rightButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .mainBlue
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medimu", size: 16)
    button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    button.layer.cornerRadius = 8
    return button
  }()
  
  private let completeButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .mainBlue
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medimu", size: 16)
    button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    button.layer.cornerRadius = 8
    return button
  }()
  
  private lazy var buttonStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  init(title: String,
       desc: String,
       leftButtonTitle: String = "취소",
       rightButtonTitle: String = "삭제",
       checkCompleteButton: Bool = false) {
    
    self.titleLabel.text = title
    self.descLabel.text = desc
    self.leftButton.setTitle(leftButtonTitle, for: .normal)
    self.rightButton.setTitle(rightButtonTitle, for: .normal)
    self.completeButton.setTitle("확인", for: .normal)
    
    super.init(frame: .zero)
    
    self.backgroundColor = .clear
    
    self.addSubview(self.popupView)

    checkComplete = checkCompleteButton

    if checkComplete {     
      self.buttonStack.addArrangedSubview(self.completeButton)
    } else {
      self.buttonStack.addArrangedSubview(self.leftButton)
      self.buttonStack.addArrangedSubview(self.rightButton)
    }
    
    self.popupView.addSubview(self.titleLabel)
    self.popupView.addSubview(self.descLabel)
    self.popupView.addSubview(self.buttonStack)

    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.popupView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.8)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(popupView.snp.top).offset(35)
      make.left.right.equalToSuperview().inset(24)
    }
    
    self.descLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.left.right.equalToSuperview().inset(24)
    }
    if checkComplete == false {
      leftButton.snp.makeConstraints { make in
        make.height.equalTo(47)
        make.width.equalTo(rightButton) // 좌우 버튼의 크기를 같게 설정
      }
      
      rightButton.snp.makeConstraints { make in
        make.height.equalTo(47)
      }
    }
    
    buttonStack.snp.makeConstraints { make in
      make.top.equalTo(descLabel.snp.bottom).offset(30)
      make.left.equalTo(popupView).offset(10)
      make.right.equalTo(popupView).offset(-10)
      make.bottom.equalTo(popupView).offset(-15)
      if checkComplete {
        make.height.equalTo(47)
      }
    }
    
  }

  @objc private func leftButtonTapped() {
    leftButtonAction?()
  }
  
  @objc private func rightButtonTapped() {
    rightButtonAction?()
  }
  
  @objc private func completeButtonTapped(){
    completButtonAction?()
  }
}
