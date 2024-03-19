//
//  SelectPersonViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/15/24.
//

import UIKit

protocol SelectPersonProtocol {
  func selectPersonProtocol(_ nickname: String)
}

final class SelectPersonViewController: ChatListViewController {
  var delegate: SelectPersonProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItemSetting()
  }
  
  override func navigationItemSetting() {
    let homeImg = UIImage(named: "backButtonImg")?.withRenderingMode(.alwaysOriginal)
    let leftButton = UIBarButtonItem(image: homeImg,
                                     style: .plain,
                                     target: self,
                                     action: #selector(leftButtonTapped))
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.isTranslucent = false
    
    self.navigationItem.leftBarButtonItem = leftButton
  }
}

extension SelectPersonViewController {
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    let userId = Array(self.usersInChatrooms.keys)[indexPath.row]
  
    guard let nickname = self.usersInChatrooms[userId] else { return }
    delegate?.selectPersonProtocol(nickname)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    super.tableView(tableView, cellForRowAt: indexPath)
  }
}
