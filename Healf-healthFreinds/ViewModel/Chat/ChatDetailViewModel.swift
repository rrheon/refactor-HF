//
//  ChatDetailViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import Foundation

import Alamofire
import FirebaseFirestoreInternal
import FirebaseAuth
import FirebaseDatabase

final class ChatDetailViewModel: CommonViewModel {
  static let shared = ChatDetailViewModel()
  
  var chatRoomUid: String?
  var comments: [ChatModel.Comment] = []
  var userModel: ChatUserModel?
  
  func createRoom(_ destinationUid: String,
                  completion: @escaping (Bool) -> Void) {
    if self.uid == destinationUid {
      print("나 자신임")
      completion(false)
      return
    }
    
    checkBlockList(to: destinationUid) { result in
      if result {
        self.checkChatRoom(self.uid ?? "", destinationUid) { chatRoomId in
          if let roomId = chatRoomId {
            // 이미 채팅방이 존재하는 경우
            print("이미 채팅방이 존재합니다.")
            completion(false)
          } else {
            // 채팅방 생성
            let createRoomInfo = [ "UserData": [ "\(self.uid ?? "")": true,
                                                 "\(destinationUid)": true] ]
            self.ref.child("chatrooms").childByAutoId().setValue(createRoomInfo) { err, ref in
              if err == nil {
                self.checkChatRoom(self.uid ?? "", destinationUid) { _ in
                  completion(true)
                }
              } else {
                completion(false)
              }
            }
          }
        }
        
        completion(true)
      } else {
        completion(false)
      }
    }
  }
  
  func checkMessageOption(destinationUid: String,
                          completion: @escaping (String?) -> Void) {
    ref.child("UserDataInfo").child(destinationUid).observeSingleEvent(of: .value) { snapshot in
      guard let userData = snapshot.value as? [String: Any],
            let messageOption = userData["messageOption"] as? String else {
        return
      }
      completion(messageOption)
    }
  }
  
  func getUserToken(completion: @escaping (String?) -> Void) {
    ref.child("UserDataInfo").child(uid ?? "").observeSingleEvent(of: .value) { snapshot in
      guard let userData = snapshot.value as? [String: Any],
            let token = userData["pushToken"] as? String else {
        return
      }
      
      completion(token) // 사용자의 위치 정보를 반환하고 완료 핸들러 호출
    }
  }
  
  func sendGcm(destinationUid: String){
    let url = "https://fcm.googleapis.com/v1/projects/healf-7f799/messages:send"
    let header: HTTPHeaders = [
      "Content-Type" : "application/json",
      "Authorization" : "Bearer"
    ]
    
    getUserToken { token in
      var notificationModel = NotificationModel()
      notificationModel.to = token
      print(notificationModel.to)
      notificationModel.notification.title = "보낸이 아이디"
      notificationModel.notification.text = "보낸 메세지"
      
      let params = notificationModel.toJSON()
      AF.request(url, method: .post, parameters: params,
                 encoding: JSONEncoding.default,headers: header).responseJSON { response in
        print(response.response)
      }
    }
    
  }
  
  // 체크 쳇룸 함수-> 쳇룸아이디 바다와야함 ->갯 목적지 uid 함수 -> 유저 모델에 값넣기-> 겟 메세지리스트 함수-> 메세지 추가 -> 챗 테이블 리로드
  func checkChatRoom(_ uid: String,
                     _ destinationUid: String,
                     completion: @escaping (String?) -> Void) {
    ref.child("chatrooms").observeSingleEvent(of: .value, with: { snapshot in
      for child in snapshot.children {
        guard let chatSnapshot = child as? DataSnapshot,
              let chatData = chatSnapshot.value as? [String: Any] else {
          continue
        }
        if let chatModel = ChatModel(JSON: chatData),
           chatModel.users[uid] == true,
           chatModel.users[destinationUid] == true {
          completion(chatSnapshot.key)
          return
        }
      }
      // 채팅방을 찾지 못한 경우 nil 반환
      completion(nil)
    })
  }
  
  func getDestinationInfo(_ destinationUid: String,
                          completion: @escaping ([String: Any]) -> Void){
    ref.child("UserData").child(destinationUid)
      .observeSingleEvent(of: DataEventType.value, with: { (dataSnapshot) in
        completion(dataSnapshot.value as! [String: Any])
        //      self.userModel = UserModel()
        //      self.userModel?.setValuesForKeys(dataSnapshot.value as! [String: Any])
        //        self.getMessageList { result in
        //          print(result)
        //        }
      })
  }
  
  func getMessageList(_ chatRoomUid: String,
                      completion: @escaping ([ChatModel.Comment]) -> Void){
    ref.child("chatrooms").child(chatRoomUid).child("comments")
      .observe(DataEventType.value, with: { (datasnapshot) in
        
        self.comments.removeAll()
        
        for item in datasnapshot.children.allObjects as! [DataSnapshot] {
          let comment = ChatModel.Comment(JSON: item.value as! [String: AnyObject])
          self.comments.append(comment!)
        }
        completion(self.comments)
      })
  }
  
  func sendMessage(_ uid: String,
                   _ message: String,
                   _ chatRoomUid: String,
                   destinationUid: String,
                   completion: @escaping (Bool) -> Void){
    checkBlockList(to: destinationUid) { result in
      if result {
        let value: Dictionary<String,Any> = [
          "uid": uid,
          "message": message,
          "timeStamp": ServerValue.timestamp()
        ]
        self.ref.child("chatrooms").child(chatRoomUid).child("comments").childByAutoId().setValue(value)
        completion(true)
      } else {
        completion(false)
      }
    }
  }
  
  func deleteChatroom(otherUserUID: String,
                      completion: @escaping () -> Void) {
    ref.child("chatrooms")
      .queryOrdered(byChild: "UserData/\(uid ?? "")")
      .queryEqual(toValue: true)
      .observeSingleEvent(of: .value, with: { (snapshot) in
        guard let chatroomsSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
          completion()
          return
        }
        for roomSnapshot in chatroomsSnapshot {
          guard let userData = roomSnapshot.childSnapshot(forPath: "UserData").value as? [String: Bool],
                let currentUserParticipated = userData[self.uid ?? ""],
                let otherUserParticipated = userData[otherUserUID],
                currentUserParticipated && otherUserParticipated else {
            continue
          }
          // 채팅방 ID를 얻어옵니다.
          let chatroomId = roomSnapshot.key
          // 채팅방 데이터베이스에서 채팅방 삭제
          self.ref.child("chatrooms").child(chatroomId).removeValue()
        }
        completion()
      })
  }
  
  func addBlockList(destinationUid: String,
                    completion: @escaping () -> Void){
    self.ref.child("BlckList").child(uid ?? "").child(destinationUid).setValue(true) { (error, ref) in
      if let error = error {
        print("Error:", error.localizedDescription)
      } else {
        print("사용자 차단 완료")
        completion()
      }
    }
  }
  
  func checkBlockList(to destinationUid: String,
                      completion: @escaping (Bool) -> Void) {
    // 상대방의 블랙리스트를 확인합니다.
    self.ref.child("BlckList").child(destinationUid).child(uid ?? "").observeSingleEvent(of: .value) { snapshot in
      if snapshot.exists() {
        // 상대방의 블랙리스트에 본인의 UID가 존재하면 메시지를 보낼 수 없습니다.
        completion(false)
      } else {
        // 상대방의 블랙리스트에 본인의 UID가 없으면 메시지를 보낼 수 있습니다.
        completion(true)
      }
    }
  }
  
  func sumitDeclartion(info: String,
                       destinationUid: String,
                       completion: @escaping () -> Void){
    self.ref.child("DeclartionList").child(uid ?? "").child(destinationUid).setValue(info) { (error, ref) in
      if let error = error {
        print("Error:", error.localizedDescription)
      } else {
        print("사용자 신고 완료")
        completion()
      }
    }
  }
}



