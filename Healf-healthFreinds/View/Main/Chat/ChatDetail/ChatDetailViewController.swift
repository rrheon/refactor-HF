//
//  ChatDetailViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/5/24.
//

import UIKit

import SnapKit
import FirebaseAuth

final class ChatDetailViewController: NaviHelper {
  let chatDetailViewModel = ChatDetailViewModel.shared
  
  var destinationUid: String? // 내가 보낼 uid
  var uid: String?
  var chatRoomUid: String?
  var comments: [ChatModel.Comment] = []
  var userModel: ChatUserModel?
  
  private lazy var messageTextfield = UIHelper.shared.createGeneralTextField("메세지를 입력해주세요.")
  private lazy var sendMessageButton = UIHelper.shared.createHealfButton("전송", .mainBlue, .white)
  
  private lazy var chatTableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ChatDetailCell.self, forCellReuseIdentifier: ChatDetailCell.cellId)
    //    tableView.register(UINib(nibName: ChatDetailCell.cellId, bundle: nil), forCellReuseIdentifier: "ReusableCell")
    tableView.rowHeight = UITableView.automaticDimension
    
    return tableView
  }()
  
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    uid = Auth.auth().currentUser?.uid
    navigationItemSetting()
    settingNavigationTitle(title: "작성자 이름")
    
    setupLayout()
    makeUI()
  
    checkChatRoom()
  }
  
  func setupLayout(){
    [
      chatTableView,
      messageTextfield,
      sendMessageButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    chatTableView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalTo(messageTextfield.snp.top).offset(-20)
    }
    
    messageTextfield.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalTo(sendMessageButton.snp.leading).offset(-20)
      $0.bottom.equalTo(sendMessageButton.snp.top).offset(-20)
    }
    
    sendMessageButton.addAction(UIAction { _ in
      self.sendMessage()
    }, for: .touchUpInside)
    sendMessageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-20)
      $0.width.equalTo(100)
    }
  }
  
  func sendMessage(){
    guard let uid = uid,
          let message = messageTextfield.text,
          let chatRoomUid = chatRoomUid else { return }
    chatDetailViewModel.sendMessage(uid, message, chatRoomUid)
  }
  
  func checkChatRoom(){
    guard let uid = uid,
          let destinationUid = destinationUid else { return }
    chatDetailViewModel.checkChatRoom(uid, destinationUid) { key in
      self.chatRoomUid = key
      
      self.chatDetailViewModel.getDestinationInfo(self.destinationUid!) { dataSnapshot in
        self.userModel = ChatUserModel()
        self.userModel?.setValuesForKeys(dataSnapshot)
        
        self.chatDetailViewModel.getMessageList(self.chatRoomUid ?? "") { comment in
          self.comments.removeAll()
          
          self.comments.append(contentsOf: comment)
          self.chatTableView.reloadData()
        }
      }
    }
  }
}

// MARK: - tableView setting
extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let messageCell = tableView.dequeueReusableCell(withIdentifier: "ChatDetailCell",
                                                    for: indexPath) as! ChatDetailCell
    messageCell.chatInfoLabel.text = self.comments[indexPath.row].message
    messageCell.chatUserProfileImageView.isHidden = self.comments[indexPath.row].uid == uid ? true : false
  
    return messageCell
  }
}
