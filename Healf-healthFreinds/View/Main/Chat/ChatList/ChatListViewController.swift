//
//  ChatViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit
import FirebaseDatabase
import FirebaseAuth
import ObjectMapper

// 따로 빼기
class UserModel: NSObject {
  @objc var nickname: String?
  @objc var uid: String?
}

//. ObjectMapper 라이브러리를 사용하면 복잡한 JSON 데이터를 다룰 때 코드의 가독성과 유지보수성을 높일 수 있다~
class ChatModel: Mappable {
  public var users: Dictionary<String, Bool> = [:] // 채팅방에 참여한 사람들
  public var comments: Dictionary<String, Comment> = [:] // 채팅방의 대화내용
  required init?(map: Map){}
  /*
   <- 연산자는 매핑을 수행하는데 사용, UserData키에 해당하는 JSON 데이터를 users 속성에,
   Comments키에 해당하는 JSON 데이터를 comments 속성에 매핑
   */
  func mapping(map: Map) {
    users <- map["UserData"]
    comments <- map["Comments"]
  }
  
  public class Comment: Mappable {
    public var uid: String?
    public var message: String?
// ObjectMapper가 객체를 생성하고 매핑하는 데 필요한 메서드를 제공하므로 명시적으로 초기화 메서드를 구현할 필요가 없다.
    public required init(map: Map){}
    public func mapping(map: Map){
      uid <- map["uid"]
      message <- map["message"]
    }
  }
}

final class ChatViewController: NaviHelper {

  var usersInChatrooms: [String: String] = [:]
  let currentUserUID = Auth.auth().currentUser?.uid
  var array: [UserModel] = []
  
  private let searchBar = UISearchBar.createSearchBar(placeholder: "원하는 내용을 검색하세요.")
  
  private lazy var chatTableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.cellId)
    tableView.rowHeight = UITableView.automaticDimension
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
    
    // 자기자신 빼기, 비어있을 경우 모두 출력되는 오류
    Database.database().reference().child("chatrooms").observe(DataEventType.value, with: { (snapshot) in
      self.usersInChatrooms.removeAll() // 기존 데이터를 제거하고 새로운 데이터로 갱신
      
      var currentUserParticipated = false // 현재 사용자가 참여한 채팅방인지 여부를 나타내는 변수
      
      for child in snapshot.children {
        let roomSnapshot = child as! DataSnapshot
        
        // 각 채팅방의 UserData 노드에 접근하여 사용자 UID 가져오기
        if let userDataSnapshot = roomSnapshot.childSnapshot(forPath: "UserData").children.allObjects as? [DataSnapshot] {
          // 현재 사용자의 UID와 관련된 채팅방인지 확인
          for userSnapshot in userDataSnapshot {
            let userId = userSnapshot.key
            let userParticipated = userSnapshot.value as! Bool
            
            if userId == self.currentUserUID && userParticipated {
              currentUserParticipated = true
              break
            }
          }
          
          // 채팅방이 하나라도 있을 경우에만 사용자 정보를 가져옴
          if currentUserParticipated {
            for userSnapshot in userDataSnapshot {
              let userId = userSnapshot.key
              let userParticipated = userSnapshot.value as! Bool
              if userParticipated && userId != self.currentUserUID {
                // 사용자의 UID를 키로 사용하여 닉네임 가져오기
                Database.database().reference().child("UserData").child(userId).observeSingleEvent(of: .value, with: { (userSnapshot) in
                  if let userData = userSnapshot.value as? [String: Any] {
                    let nickname = userData["nickname"] as? String ?? "Unknown"
                    self.usersInChatrooms[userId] = nickname
                    self.chatTableView.reloadData() // 데이터를 받은 후에 테이블 뷰 갱신
                  }
                })
              }
            }
          }
        }
      }
    })
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
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    return self.usersInChatrooms.count
    return usersInChatrooms.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chatDetailVC = ChatDetailViewController()
    chatDetailVC.destinationUid = Array(self.usersInChatrooms.keys)[indexPath.row]
//    chatDetailVC.destinationUid = array[indexPath.row].uid
    chatDetailVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(chatDetailVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellId,
                                             for: indexPath) as! ChatCell
    let userId = Array(self.usersInChatrooms.keys)[indexPath.row]

    let nickname = self.usersInChatrooms[userId]
    cell.userNickNameLabel.text = nickname
//    cell.userNickNameLabel.text = array[indexPath.row].nickname
    return cell
  }
  
}
