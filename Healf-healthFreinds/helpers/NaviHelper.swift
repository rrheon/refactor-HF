//
//  NaviHelper.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/02/05.
//
import UIKit

class NaviHelper: UIViewController {
  lazy var uihelper = UIHelper.shared
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - navi 설정
  func navigationItemSetting() {
    let homeImg = UIImage(named: "backButtonImg")?.withRenderingMode(.alwaysOriginal)
    let leftButton = UIBarButtonItem(image: homeImg,
                                     style: .plain,
                                     target: self,
                                     action: #selector(leftButtonTapped))
    
    let plusImg = UIImage(named: "PlusImg")?.withRenderingMode(.alwaysOriginal)
    let plusButton = UIBarButtonItem(image: plusImg,
                                     style: .plain,
                                     target: self,
                                     action: #selector(rightButtonTapped))
    plusButton.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)


    
    self.navigationItem.leftBarButtonItem = leftButton
    self.navigationItem.rightBarButtonItem = plusButton
  }
  
  // MARK: - 네비게이션 바 제목설정
  func settingNavigationTitle(title: String){
    self.navigationItem.title = title
    self.navigationController?.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
    ]
  }
  
  @objc func leftButtonTapped(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func rightButtonTapped(_ sender: UIBarButtonItem){
    let createPostVC = CreatePostViewController()
    createPostVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(createPostVC, animated: true)
  }
  
  func redesignNavigation(_ imageName: String){
    let logoImg = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
    let logo = UIBarButtonItem(image: logoImg, style: .done, target: nil, action: nil)
    logo.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
    logo.isEnabled = false
    
    navigationItem.leftBarButtonItem = logo
  }
}
