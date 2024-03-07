//
//  UISearchBar+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/1/24.
//

import UIKit

extension UISearchBar {
  static func createSearchBar(placeholder: String) -> UISearchBar {
    let bar = UISearchBar()
  
    bar.placeholder = placeholder
    bar.searchTextField.font = .boldSystemFont(ofSize: 20)
    
    if let searchBarTextField = bar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.font = UIFont.systemFont(ofSize: 14)
      searchBarTextField.layer.cornerRadius = 10
      searchBarTextField.layer.masksToBounds = true
      searchBarTextField.backgroundColor = .white
      searchBarTextField.layer.borderColor = UIColor.lightGray.cgColor
      searchBarTextField.layer.borderWidth = 0.5
    }
    
    let searchImg = UIImage(named: "SearchImg")?.withRenderingMode(.alwaysOriginal)
    
    bar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    
    bar.showsBookmarkButton = true
    bar.setImage(searchImg, for: .bookmark, state: .normal)
    
    bar.backgroundImage = UIImage()
    
    return bar
  }
}
