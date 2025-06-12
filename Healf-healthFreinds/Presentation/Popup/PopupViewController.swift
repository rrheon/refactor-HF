//
//  PopupViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit


/// 팝업 뷰 UI
struct PopupViewUI {
  var title: String?
  var description: String?
  var leftBtnTitle: String?
  var rightBtnTitle: String?
  var isEndBtn: Bool = false
}

/// 팝업의 종류
enum PopupCase {
  case failToLogin
  case error
  
  var popupData: PopupViewUI {
    switch self {
    case .failToLogin:
      return PopupViewUI(title: "아이디, 비밀번호를 확인해주세요.", isEndBtn: true)
    case .error :
      return PopupViewUI(description: "잠시후 다시 시도해주세요.", isEndBtn: true)
    }
  }
}


/// 팝업 ViewController
final class PopupViewController: UIViewController {
  let popupView: PopupView
  private lazy var dissmissAction: () -> ()  = {
    self.dismiss(animated: true)
  }
  
  /// 팝업 생성
  /// - Parameter type: 팝업의 종류
  init(with type: PopupCase) {
    self.popupView = PopupView(with: type)
    super.init(nibName: nil, bundle: nil)

    self.popupView.dismissAction = dissmissAction

    self.view.backgroundColor = .lightGray.withAlphaComponent(0.8)
    
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    
    self.view.addSubview(self.popupView)
    self.popupView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
