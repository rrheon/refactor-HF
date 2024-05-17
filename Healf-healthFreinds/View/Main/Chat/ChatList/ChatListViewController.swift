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
    
  private lazy var chatTableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.cellId)
    tableView.rowHeight = UITableView.automaticDimension
    
    return tableView
  }()
  
  private lazy var noneChatRoomList = uihelper.createMultipleLineLabel(
    "진행 중인 채팅이 없습니다\n 새로운 헬스 친구를 찾아보세요 💪🏻")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    getChatList {
      self.setupLayout()
      self.makeUI()
    }
    
    nonChatList()
  }
  
  override func navigationItemSetting() {
    self.navigationController?.navigationBar.tintColor = .white

    redesignNavigation("ChatTitleImg")
  }
  
  func setupLayout(){
    [
      chatTableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    chatTableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.trailing.bottom.equalToSuperview()
      //      $0.height.equalTo(120)
    }
  }
  
  func nonChatList(){
    if usersInChatrooms.count == 0 {
      view.addSubview(noneChatRoomList)
      noneChatRoomList.snp.makeConstraints {
        $0.centerX.centerY.equalToSuperview()
      }
    }
  }
  
  func getChatList(completion: @escaping () -> Void){
    self.usersInChatrooms.removeAll()
    chatListViewModel.getAllChatroomData(currentUserUID: currentUserUID ?? "") { result in
      var numberOfMessagesReceived = 0 // 받은 메시지 수를 추적
      print(result)
      if result.isEmpty {
        // 데이터가 없는 경우에도 completion을 실행
        self.chatTableView.reloadData()
        completion()
      } else {
        for data in result {
          self.usersInChatrooms[data.1] = data.2
          self.chatListViewModel.getLastMessage(data.0) { lastMessage in
            self.usersLastMessage[data.1] = lastMessage
            
            numberOfMessagesReceived += 1
            if numberOfMessagesReceived == result.count { 
              self.chatTableView.reloadData()
              completion()
            }
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
    
    let nickname = self.usersInChatrooms[userId]
    let lastMessage = self.usersLastMessage[userId]
    cell.model = .init(uid: userId,
                       nickname: nickname ?? "이름",
                       lastMessage: lastMessage?.message ?? "채팅내역 없음",
                       timeStamp: lastMessage?.timeStamp?.todayTime ?? "")
    
    return cell
  }
}
