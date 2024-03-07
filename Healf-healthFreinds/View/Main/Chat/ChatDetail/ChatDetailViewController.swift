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

final class ChatDetailViewController: NaviHelper{
  var destinationUid: String? // 내가 보낼 uid
  
  var uid: String?
  var chatRoomUid: String?
  
  let db = Firestore.firestore()

  var messages: [MessageDTO] = []
  
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
    
    loadMessages()
    
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
    checkChatRoom()
    
    guard chatRoomUid == nil else { return }
    
    let createRoomInfo = [ "UserData": [ "\(uid!)": true, "\(destinationUid!)": true] ]
    
    Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo)
  }

  
  func checkChatRoom(){
    Database.database().reference().child("chatrooms").queryOrdered(byChild: "UserData/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
      for item in datasnapshot.children.allObjects as! [DataSnapshot]{
        self.chatRoomUid = item.key
      }
    })
  }
  
  // MARK: - sendMessage
  func sendMessage(_ sender: UIButton){
    if let messageBody = messageTextfield.text,
       let messageSender = Auth.auth().currentUser?.email {
      db.collection("messages").addDocument(data: [
        "sender": messageSender,
        "body": messageBody,
        "date": Date().timeIntervalSince1970]) { (error) in
          if let e = error {
            print(e.localizedDescription)
          } else {
            print("Succes save data")
            
            DispatchQueue.main.async {
              self.messageTextfield.text = ""
            }
          }
        }
    }
  }
  
  private func loadMessages(){
    guard let currentUserEmail = Auth.auth().currentUser?.email else {
      print("Current user's email is not available.")
      return
    }
    
    
    db.collection("messages")
      .order(by: "date")
      .addSnapshotListener { querySnapshot, error in
        self.messages = []
        
        if let e = error {
          print(e.localizedDescription)
        } else {
          if let snapshotDocuments = querySnapshot?.documents {
            snapshotDocuments.forEach { (doc) in
              let data = doc.data()
              if let sender = data["sender"] as? String,
                 let body = data["body"] as? String {
                self.messages.append(MessageDTO(sender: sender, body: body))
                
                DispatchQueue.main.async {
                  self.chatTableView.reloadData()
                  self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0),
                                                 at: .top,
                                                 animated: false)
                }
              }
            }
          }
        }
      }
    
  }
}

// MARK: - tableView setting
extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let messageCell = tableView.dequeueReusableCell(withIdentifier: "ChatDetailCell",
                                                    for: indexPath) as! ChatDetailCell
    
    let message = messages[indexPath.row]
    
    if message.sender == Auth.auth().currentUser?.email {
      messageCell.chatUserProfileImageView.isHidden = true
      messageCell.myProfileImageView.isHidden = false
      messageCell.chatInfoLabel.backgroundColor = .lightGray
      messageCell.chatInfoLabel.textColor = .black
    } else {
      messageCell.chatUserProfileImageView.isHidden = false
      messageCell.myProfileImageView.isHidden = true
      messageCell.chatInfoLabel.backgroundColor = .black
      messageCell.chatInfoLabel.textColor = .white
    }
    
    messageCell.chatInfoLabel.text = messages[indexPath.row].body
    return messageCell
  }
}
