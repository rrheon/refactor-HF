//
//   DeclarationViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/22/24.
//

import UIKit

import SnapKit

final class DeclarationViewController: NaviHelper {
  private lazy var titleLabel = uihelper.createSingleLineLabel("신고하실 내역을 입력해주세요.")
  private lazy var writeDetailInfoTextView = uihelper.createGeneralTextView("내용을 입력하세요.")
  private lazy var sumitButton = uihelper.createHealfButton("제출하기",
                                                            .mainBlue,
                                                            .white)
  
  var destinationUid: String?
  
  init(destinationUid: String?) {
    super.init()
    
    self.destinationUid = destinationUid
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  
    navigationItemSetting()
    
    setupLayout()
    makeUI()
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    settingNavigationTitle(title: "신고하기")
  }
  
  func setupLayout(){
    [
      titleLabel,
      writeDetailInfoTextView,
      sumitButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    writeDetailInfoTextView.delegate = self
    writeDetailInfoTextView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(150)
    }
    
    sumitButton.addAction(UIAction { _ in
      self.sumitButtonTapped()
    }, for: .touchUpInside)
    sumitButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalTo(view.snp.bottom).offset(-50)
      $0.height.equalTo(50)
    }
  }
  
  func sumitButtonTapped(){
    guard let text = writeDetailInfoTextView.text else { return }
    ChatDetailViewModel.shared.sumitDeclartion(info: text,
                                               destinationUid: destinationUid ?? "") {
      self.writeDetailInfoTextView.resignFirstResponder()
      self.showPopupViewWithOnebuttonAndDisappearVC("신고가 완료되었습니다.\n 24시간 이내에 처리될 예정입니다.")
    }
  }
}
