//
//  ChatDetailViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/5/24.
//

import UIKit

import SnapKit
import FirebaseFirestoreInternal
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper

final class ChatDetailViewController: NaviHelper{
  var destinationUid: String? // 내가 보낼 uid
  
  var uid: String?
  var chatRoomUid: String?
  var comments: [ChatModel.Comment] = []
  var userModel: UserModel?
  
  
  private lazy var messageTextfield: UITextField = {
    let textfield = UITextField()
    textfield.placeholder = "메세지를 입력해주세요."
    textfield.layer.borderWidth = 1
    textfield.layer.borderColor = UIColor.black.cgColor
    return textfield
  }()
  
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
      self.createRoom()
    }, for: .touchUpInside)
    sendMessageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-20)
      $0.width.equalTo(100)
    }
  }
  
  func createRoom(){
//    checkChatRoom()
//    
//    guard chatRoomUid == nil else { return }
    
    let createRoomInfo = [ "UserData": [ "\(uid!)": true,
                                         "\(destinationUid!)": true] ]
    
    if (chatRoomUid == nil) {
      self.sendMessageButton.isEnabled = false
      Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo) { err, ref in
        if err == nil {
          self.checkChatRoom()
  
        }
      }
    } else {
      let value: Dictionary<String,Any> = [
          "uid": uid!,
          "message": messageTextfield.text!
        ]
      Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)

    }
    
  
  }

  
  func checkChatRoom(){
    Database.database()
      .reference()
      .child("chatrooms")
      .queryOrdered(byChild: "UserData/"+uid!)
      .queryEqual(toValue: true)
      .observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
      for item in datasnapshot.children.allObjects as! [DataSnapshot]{
        if let chatRoomdic = item.value as? [String: AnyObject] {
          let chatModel = ChatModel(JSON: chatRoomdic)
          if (chatModel?.users[self.destinationUid!] == true){
            self.chatRoomUid = item.key
            self.sendMessageButton.isEnabled = true
            self.getDestinationInfo()
          }
        }
      }
    })
  }
  
  func getDestinationInfo(){
    Database.database()
      .reference()
      .child("UserData")
      .child(self.destinationUid!)
      .observeSingleEvent(of: DataEventType.value, with: {(dataSnapshot) in
      self.userModel = UserModel()
      self.userModel?.setValuesForKeys(dataSnapshot.value as! [String: Any])
      self.getMessageList()
    })
  }
  
  func getMessageList(){
    Database.database()
      .reference()
      .child("chatrooms")
      .child(self.chatRoomUid!)
      .child("comments")
      .observe(DataEventType.value, with: { (datasnapshot) in
      
      self.comments.removeAll()
      
      for item in datasnapshot.children.allObjects as! [DataSnapshot] {
        let comment = ChatModel.Comment(JSON: item.value as! [String: AnyObject])
        self.comments.append(comment!)
        
//        if let value = item.value as? [String: AnyObject] {
//            let comment = ChatModel.Comment(JSON: value)
//          self.comments.append(comment!)
//        }
      }
      self.chatTableView.reloadData()
    })
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
    if self.comments[indexPath.row].uid == uid {
      messageCell.chatUserProfileImageView.isHidden = true

    } else {
      messageCell.chatUserProfileImageView.isHidden = false
    }
    
    

    return messageCell
  }
}
