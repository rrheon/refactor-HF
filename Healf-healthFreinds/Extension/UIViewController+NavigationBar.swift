//
//  UIViewController+NavigationBar.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 6/5/25.
//


import UIKit

extension UIViewController {
  
  /// 왼쪽 아이템 버튼 설정
  /// - Parameters:
  ///   - imgName: 이미지 - 기본값 = 왼쪽 화살표
  ///   - activate: 버튼 액션 활성화 여부
  func leftButtonSetting(imgName: String = BtnImages.backBtn,
                         activate: Bool = true) {
    let homeImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
    let leftButton = UIBarButtonItem(
      image: homeImg,
      style: .plain,
      target: self,
      action: #selector(leftBarBtnTapped))
    leftButton.isEnabled = activate
    self.navigationItem.leftBarButtonItem = leftButton
  }

  @objc func leftBarBtnTapped(_ sender: UIBarButtonItem){}
  
  /// 오른쪽 아이템 버튼 설정
  /// - Parameters:
  ///   - imgName: 이미지 이름
  ///   - activate: 오른쪽 버튼 활성화 여부
  func rightButtonSetting(imgName: String, activate: Bool = true) {
    let rightButtonImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
    lazy var rightButton = UIBarButtonItem(
      image: rightButtonImg,
      style: .plain,
      target: self,
      action: #selector(rightBarBtnTapped))
    rightButton.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    rightButton.isEnabled = activate
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  @objc func rightBarBtnTapped(_ sender: UIBarButtonItem){}
  
  /// 네비게이션 바 UI 설정
  func settingNavigationbar() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .black
    appearance.shadowColor = .clear
    
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 18)!
    ]
    
    self.navigationController?.navigationBar.standardAppearance = appearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }
  
  
  /// 네비게이션 바 타이틀 설정
  /// - Parameters:
  ///   - title: 제목
  ///   - font: 폰트
  ///   - size: 사이즈
  func settingNavigationTitle(title: String, font: String = "Pretendard-Bold", size: CGFloat = 18) {
    self.navigationItem.title = title
    
    if let appearance = self.navigationController?.navigationBar.standardAppearance {
      appearance.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: font, size: size)!
      ]
      
      self.navigationController?.navigationBar.standardAppearance = appearance
      self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
  }
  
  /// 스크롤 시 네비게이션 바 색상 변경 방지
  func configurationNavigationBar(){
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithTransparentBackground()
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
  }
}

