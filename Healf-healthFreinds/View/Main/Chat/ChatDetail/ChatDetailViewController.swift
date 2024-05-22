//
//  ChatDetailViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/5/24.
//

import UIKit

import SnapKit
import FirebaseAuth
import Then

// 메세지 보낼 때 키보드가 가림
final class ChatDetailViewController: NaviHelper {
  let chatDetailViewModel = ChatDetailViewModel.shared
  
  var destinationUid: String? // 내가 보낼 uid
  var uid: String?
  var chatRoomUid: String?
  var userNickname: String?
  
  var comments: [ChatModel.Comment] = []
  var userModel: ChatUserModel?
  
  private lazy var messageTextfield = UITextField().then {
    $0.layer.borderWidth = 1
    $0.placeholder = "메세지를 입력해주세요."
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.cornerRadius = 10
    $0.backgroundColor =  .init(hexCode: "F5F5F5")
  }
  
  private lazy var sendMessageButton = UIButton().then {
    $0.setImage(UIImage(named: "SendButtonImg"), for: .normal)
  }
  
  private lazy var chatTableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(DestinationChatCelll.self, forCellReuseIdentifier: DestinationChatCelll.cellId)
    tableView.register(MyChatCell.self, forCellReuseIdentifier: MyChatCell.cellId)
    //    tableView.register(UINib(nibName: ChatDetailCell.cellId, bundle: nil), forCellReuseIdentifier: "ReusableCell")
    tableView.rowHeight = UITableView.automaticDimension
    tableView.allowsSelection = false
    tableView.separatorStyle = .none
    return tableView
  }()
  
  init(destinationUid: String? = nil,
       userNickname: String? = nil) {
    super.init()
    
    self.destinationUid = destinationUid
    self.userNickname = userNickname
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    uid = Auth.auth().currentUser?.uid
    
    setupLayout()
    makeUI()
    
    checkChatRoom()
    navigationItemSetting()
    
    showPopupViewWithOneButton("부적절하거나 불쾌감을 줄 수 있는 컨텐츠를 게시할 경우 제재를 받을 수 있습니다.")
    
    hideKeyboardWhenTappedAround()
    setupKeyboardEvent()
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()

    settingNavigationTitle(title: userNickname ?? "")

    let rightButtonImg = UIImage(named: "ChatMenuImg")?.withRenderingMode(.alwaysOriginal)
    let rightButton = UIBarButtonItem(image: rightButtonImg,
                                     style: .plain,
                                     target: self,
                                     action: #selector(participateButtonTapped))
    rightButton.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    self.navigationItem.rightBarButtonItem = rightButton
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
      $0.trailing.equalTo(sendMessageButton.snp.leading).offset(-10)
      $0.top.equalTo(view.snp.bottom).offset(-60)
      $0.height.equalTo(40)
    }
    
    sendMessageButton.addAction(UIAction { _ in
      self.sendMessage()
    }, for: .touchUpInside)
    sendMessageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(messageTextfield)
      $0.width.equalTo(50)
    }
  }
  
  func sendMessage(){
    guard let uid = uid,
          let message = messageTextfield.text, message != "",
          let chatRoomUid = chatRoomUid else { return }
    chatDetailViewModel.sendMessage(uid,
                                    message,
                                    chatRoomUid,
                                    destinationUid: destinationUid ?? "") { result in
      self.messageTextfield.text = ""
      if result {
        self.chatDetailViewModel.sendGcm(destinationUid: self.destinationUid ?? "")
        self.arrangeChatCellRecently()
      } else {
        self.showPopupViewWithOneButton("채팅을 보낼 수 없습니다.")
      }
    }
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
          
          self.arrangeChatCellRecently()
        }
      }
    }
  }
  
  func arrangeChatCellRecently(){
    if self.comments.count > 0 {
      self.chatTableView.scrollToRow(at: IndexPath(item: self.comments.count - 1,
                                                   section: 0),
                                     at: UITableView.ScrollPosition.bottom, animated: true)
    }
  }
  
  func updateLastCell() {
    chatTableView.beginUpdates()
    let newIndexPath = IndexPath(row: self.comments.count - 1, section: 0)
    chatTableView.insertRows(at: [newIndexPath], with: .bottom)
    chatTableView.endUpdates()
    
    // Adjust content offset to prevent constraint issues
    let contentHeight = chatTableView.contentSize.height
    let tableViewHeight = chatTableView.bounds.size.height
    if contentHeight > tableViewHeight {
      let offset = CGPoint(x: 0, y: contentHeight - tableViewHeight)
      chatTableView.setContentOffset(offset, animated: true)
    }
  }
  
  @objc func participateButtonTapped() {
    let bottomSheetVC = BottomSheet(firstButtonTitle: "신고하기",
                                    secondButtonTitle: "사용자 차단하기",
                                    checkPost: true)
    bottomSheetVC.delegate = self
    
    uihelper.settingBottomeSheet(bottomSheetVC: bottomSheetVC, size: 220)
    present(bottomSheetVC, animated: true, completion: nil)
  }
}

// MARK: - tableView setting
extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let comment = self.comments[indexPath.row]
    let checkSendOrReceive = comment.uid == uid ? ChatType.send : ChatType.receive
    var commentTime: String = ""
    
    if let time = comment.timeStamp { 
      commentTime = time.todayTime
   }
    
    if checkSendOrReceive == .send {
      let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell",
                                               for: indexPath) as! MyChatCell
      cell.model = .init(message: comment.message ?? "", timeStamp: commentTime)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationChatCell",
                                               for: indexPath) as! DestinationChatCelll
      cell.model = .init(message: comment.message ?? "", timeStamp: commentTime)
      return cell
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let comment = comments[indexPath.row]
      let estimatedFrame = comment.message?.getEstimatedFrame(with: .systemFont(ofSize: 18))
      return (estimatedFrame?.height ?? 0) + 30
  }
}

extension ChatDetailViewController: BottomSheetDelegate {
  func firstButtonTapped(_ postedData: CreatePostModel?) {
// 신고하기 페이지로 이동, 본인 uid, 상대방 uid, 내용
    dismiss(animated: true)
    let declarationVC = DeclarationViewController(destinationUid: destinationUid ?? "")
    navigationController?.pushViewController(declarationVC, animated: true)
  }
  
  func secondButtonTapped(_ postedData: CreatePostModel?) {
    chatDetailViewModel.addBlockList(destinationUid: destinationUid ?? "") {
      self.dismiss(animated: true)
      self.showPopupViewWithOneButton("차단이 완료되었습니다")
    }
  }
}
