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
  
  /// 채팅방 생성 함수
  /// - Parameters:
  ///   - destinationUid: 채팅을 시작할 상대방의 UID
  ///   - completion: 채팅방 생성 성공 여부를 반환하는 클로저
  func createRoom(_ destinationUid: String,
                  completion: @escaping (Bool) -> Void) {
    
    // 사용자가 자기 자신과 채팅을 시도하는 경우 생성 불가
    if self.uid == destinationUid {
      completion(false)
      return
    }
    
    // 차단 목록을 확인하여 상대방과 채팅이 가능한지 검사
    checkBlockList(to: destinationUid) { result in
      if result { // 차단 목록에 없는 경우 진행
        // 기존에 동일한 채팅방이 존재하는지 확인
        self.checkChatRoom(self.uid ?? "", destinationUid) { chatRoomId in
          if let roomId = chatRoomId {
            // 이미 채팅방이 존재하는 경우 생성하지 않고 종료
            completion(false)
          } else {
            // 새로운 채팅방을 생성
            let createRoomInfo = [
              "UserData": [
                "\(self.uid ?? "")": true,  // 현재 사용자 UID
                "\(destinationUid)": true  // 상대방 UID
              ]
            ]
            
            // Firebase - chatrooms에 새로운 채팅방 생성
            self.ref.child("chatrooms").childByAutoId().setValue(createRoomInfo) { err, ref in
              if err == nil {
                // 채팅방 생성이 성공하면 다시 확인 후 완료 처리
                self.checkChatRoom(self.uid ?? "", destinationUid) { _ in
                  completion(true)
                }
              } else {
                completion(false) // 오류 발생 시 실패 처리
              }
            }
          }
        }
        
        completion(true) // 차단되지 않은 경우 true 반환
      } else {
        completion(false) // 차단된 경우 false 반환
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
  
  /// 특정 사용자 간의 채팅방 존재 여부 확인
  /// - Parameters:
  ///   - uid: 현재 사용자의 고유 ID
  ///   - destinationUid: 상대방 사용자의 고유 ID
  ///   - completion: 기존 채팅방의 ID를 반환하거나, 존재하지 않으면 nil을 반환하는 클로저
  func checkChatRoom(_ uid: String,
                     _ destinationUid: String,
                     completion: @escaping (String?) -> Void) {
      
      // Firebase - chatrooms 노드에서 단일 조회 이벤트 수행
      ref.child("chatrooms").observeSingleEvent(of: .value, with: { snapshot in
          // 채팅방 목록을 순회하면서 특정 사용자 간의 채팅방이 존재하는지 확인
          for child in snapshot.children {
              guard let chatSnapshot = child as? DataSnapshot,
                    let chatData = chatSnapshot.value as? [String: Any] else {
                  continue
              }
              
              // Firebase 데이터에서 ChatModel 객체로 변환
              if let chatModel = ChatModel(JSON: chatData),
                 chatModel.users[uid] == true,          // 현재 사용자가 해당 채팅방에 존재하는지 확인
                 chatModel.users[destinationUid] == true { // 상대방 사용자가 해당 채팅방에 존재하는지 확인
                  completion(chatSnapshot.key) // 채팅방 ID 반환
                  return
              }
          }
          
          // 해당 사용자 간의 채팅방을 찾지 못한 경우 nil 반환
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
  
  /// 특정 채팅방의 메시지 목록 가져오기
  /// - Parameters:
  ///   - chatRoomUid: 가져올 채팅방의 고유 ID
  ///   - completion: 메시지 배열을 반환하는 클로저
  func getMessageList(_ chatRoomUid: String,
                      completion: @escaping ([ChatModel.Comment]) -> Void) {
    
    // Firebase - chatrooms 에서 해당 채팅방의 comments 하위 노드 관찰
    ref.child("chatrooms").child(chatRoomUid).child("comments")
      .observe(DataEventType.value, with: { (datasnapshot) in
        
        // 기존에 저장된 메시지 목록을 초기화
        self.comments.removeAll()
        
        // 데이터 스냅샷을 순회하며 각 댓글을 가져와 배열에 추가
        for item in datasnapshot.children.allObjects as! [DataSnapshot] {
          let comment = ChatModel.Comment(JSON: item.value as! [String: AnyObject])
          self.comments.append(comment!)
        }
        
        // 메시지 목록 반환
        completion(self.comments)
      })
  }

  
  /// 메시지 전송 함수
  /// - Parameters:
  ///   - uid: 현재 사용자의 고유 ID
  ///   - message: 전송할 메시지 내용
  ///   - chatRoomUid: 메시지를 보낼 채팅방의 고유 ID
  ///   - destinationUid: 메시지를 받을 대상 사용자의 고유 ID
  ///   - completion: 메시지 전송 성공 여부를 반환하는 클로저
  func sendMessage(_ uid: String,
                   _ message: String,
                   _ chatRoomUid: String,
                   destinationUid: String,
                   completion: @escaping (Bool) -> Void) {
    
    // 대상 사용자가 차단 목록에 있는지 확인
    checkBlockList(to: destinationUid) { result in
      if result {
        let value: Dictionary<String, Any> = [
          "uid": uid,                     // 보낸 사람의 UID
          "message": message,             // 메시지 내용
          "timeStamp": ServerValue.timestamp() // 서버의 현재 타임스탬프
        ]
        
        // Firebase의 해당 채팅방 comments 노드에 새로운 메시지 추가
        self.ref.child("chatrooms").child(chatRoomUid).child("comments")
          .childByAutoId().setValue(value)
        
        // 메시지 전송 성공 시 true 반환
        completion(true)
      } else {
        // 차단된 경우 메시지 전송 불가
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



