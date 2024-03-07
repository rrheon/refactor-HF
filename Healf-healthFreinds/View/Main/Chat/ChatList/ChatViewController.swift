//
//  ChatViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit
import FirebaseDatabase

// 따로 빼기
class UserModel: NSObject {
  @objc var nickname: String?
  @objc var uid: String?
}

class ChatModel: NSObject {
  // 1대 1
  //  @objc var uid: String?
  //  @objc var destinationUid: String?

  public var users: Dictionary<String, Bool> = [:] // 채팅방에 참여한 사람들
  public var commnets: Dictionary<String, Comment> = [:] // 채팅방의 대화내용
  public class Comment{
    public var uid: String?
    public var message: String?
  }
}

final class ChatViewController: NaviHelper {
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
    
    //import FirebaseDatabase 해야함, UserData에 접근
    Database.database().reference().child("UserData").observe(DataEventType.value, with: { (snapshot) in
      self.array.removeAll()
      
      for child in snapshot.children {
        let fchild = child as! DataSnapshot
        let userModel = UserModel()
        
        userModel.setValuesForKeys(fchild.value as! [String: Any])
        self.array.append(userModel)
      }
      
      DispatchQueue.main.async {
        self.chatTableView.reloadData()
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
    return array.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chatDetailVC = ChatDetailViewController()
    chatDetailVC.destinationUid = self.array[indexPath.row].uid
    chatDetailVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(chatDetailVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellId,
                                             for: indexPath) as! ChatCell
    
    cell.userNickNameLabel.text = array[indexPath.row].nickname
    return cell
  }
  
}
