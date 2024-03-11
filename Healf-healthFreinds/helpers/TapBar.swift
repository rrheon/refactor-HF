//
//  TapBar.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2/28/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    
    let homeVC = HomeViewController()
    let homeVCwithNavi = UINavigationController(rootViewController: homeVC)
    
    let searchVC = SearchViewController()
    let searchVCwithNavi = UINavigationController(rootViewController: searchVC)
    
    let mapVC = MapViewController()
    let mapVCwithNavi = UINavigationController(rootViewController: mapVC)
    
    let chatVC = ChatListViewController()
    let chatVCwithNavi = UINavigationController(rootViewController: chatVC)
    
    let mypageVC = MypageViewController()
    let mypageVCwithNavi = UINavigationController(rootViewController: mypageVC)
    
    
    self.viewControllers = [homeVCwithNavi, searchVCwithNavi,
                            mapVCwithNavi, chatVCwithNavi, mypageVCwithNavi]
    
    homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "HomeImg"), tag: 0)
    searchVC.tabBarItem = UITabBarItem(title: "서치", image: UIImage(named: "SearchImg"), tag: 1)
    mapVCwithNavi.tabBarItem = UITabBarItem(title: "지도", image: UIImage(named: "MapImg"), tag: 2)
    chatVCwithNavi.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(named: "ChatImg"), tag: 3)
    mypageVCwithNavi.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(named: "MypageIconImg"), tag: 3)

    self.tabBar.tintColor = .mainBlue
    
    self.tabBar.layer.borderColor = UIColor.unableGray.cgColor
    self.tabBar.layer.cornerRadius = 30
    self.tabBar.layer.borderWidth = 0.5
    
    self.tabBar.backgroundColor = .white
    
  }
}
