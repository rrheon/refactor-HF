//
//  PopupViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit

final class PopupViewController: UIViewController {
  let popupView: PopupView
  
  init(title: String,
       desc: String,
       leftButtonTitle: String = "취소",
       rightButtonTilte: String = "시작",
       checkCompleteButton: Bool = false) {
    self.popupView = PopupView(title: title,
                               desc: desc,
                               leftButtonTitle: leftButtonTitle,
                               rightButtonTitle: rightButtonTilte,
                               checkCompleteButton: checkCompleteButton)
    
    super.init(nibName: nil, bundle: nil)
    
    self.view.backgroundColor = .lightGray.withAlphaComponent(0.8)
    
    self.view.addSubview(self.popupView)
    self.setupConstraints()
    
    self.popupView.leftButtonAction = { [weak self] in
        self?.dismiss(animated: true, completion: nil)
    }

    self.popupView.rightButtonAction = self.popupView.leftButtonAction
    self.popupView.completButtonAction = self.popupView.leftButtonAction
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.popupView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
