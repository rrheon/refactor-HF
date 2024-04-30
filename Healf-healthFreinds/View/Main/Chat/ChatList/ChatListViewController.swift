//
//  ChatViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit
import FirebaseAuth

class ChatListViewController: NaviHelper {
  let chatListViewModel = ChatListViewModel()
  
  var usersInChatrooms: [String: String] = [:]
  var usersLastMessage: [String: ChatModel.Comment] = [:]
  let currentUserUID = Auth.auth().currentUser?.uid
  
  private let searchBar = UISearchBar.createSearchBar(placeholder: "원하는 내용을 검색하세요.")
  
  private lazy var chatTableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.cellId)
    tableView.rowHeight = UITableView.automaticDimension
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
 
    getChatList {
      self.setupLayout()
      self.makeUI()
      
    }
  }
  
  override func navigationItemSetting() {
    redesignNavigation("ChatTitleImg")
  }
  
  func setupLayout(){
    [
      searchBar,
      chatTableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    chatTableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(20)
      $0.leading.trailing.bottom.equalToSuperview()
//      $0.height.equalTo(120)
    }
  }
  
  func getChatList(completion: @escaping () -> Void){
    self.usersInChatrooms.removeAll()
    chatListViewModel.getAllChatroomData(currentUserUID: currentUserUID ?? "") { result in
      var numberOfMessagesReceived = 0 // 받은 메시지 수를 추적
      
      for data in result {
        self.usersInChatrooms[data.1] = data.2
        self.chatListViewModel.getLastMessage(data.0) { lastMessage in
          self.usersLastMessage[data.1] = lastMessage
          
          numberOfMessagesReceived += 1
          if numberOfMessagesReceived == result.count { // 모든 메시지를 받았을 때만 테이블 뷰를 다시 로드
            self.chatTableView.reloadData()
            completion()
          }
        }
      }
    }
  }
}


extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    return self.usersInChatrooms.count
    return usersInChatrooms.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let userId = Array(self.usersInChatrooms.keys)[indexPath.row]
    let nickname = self.usersInChatrooms[userId]

    let chatDetailVC = ChatDetailViewController(destinationUid: userId, userNickname: nickname)
//    chatDetailVC.destinationUid = array[indexPath.row].uid
    chatDetailVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(chatDetailVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.cellId,
                                             for: indexPath) as! ChatListCell
    let userId = Array(self.usersInChatrooms.keys)[indexPath.row]
    if let nickname = self.usersInChatrooms[userId],
       let lastMessage = self.usersLastMessage[userId] {
        cell.model = .init(profile: "",
                         nickname: nickname,
                         lastMessage: lastMessage.message ?? "",
                         timeStamp: lastMessage.timeStamp?.todayTime ?? "")
    }
    return cell
  }
  
}
