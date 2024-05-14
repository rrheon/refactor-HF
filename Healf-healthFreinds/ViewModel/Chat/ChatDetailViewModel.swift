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
                  completion: @escaping (Bool) -> Void){
//    checkMessageOption(destinationUid: destinationUid) { [weak self] messageOption in
//      if messageOption == "true" {
//        completion(false)
//        return
//      }
      
    if self.uid == destinationUid {
        print("나 자신임")
        completion(false)
        return
      } else {
        let createRoomInfo = [ "UserData": [ "\(self.uid ?? "")": true,
                                             "\(destinationUid)": true] ]
        self.ref.child("chatrooms").childByAutoId().setValue(createRoomInfo) { err, ref in
          if err == nil {
            self.checkChatRoom(self.uid ?? "", destinationUid) { _ in
              completion(true)
            }
          }
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
                     completion: @escaping (String) -> Void){
    ref.child("chatrooms").queryOrdered(byChild: "UserData/"+uid).queryEqual(toValue: true)
      .observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
        for item in datasnapshot.children.allObjects as! [DataSnapshot]{
          if let chatRoomdic = item.value as? [String: AnyObject] {
            let chatModel = ChatModel(JSON: chatRoomdic)
            if (chatModel?.users[destinationUid] == true){
              //            self.chatRoomUid = item.key
              completion(item.key)
            }
          }
        }
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
                   completion: @escaping () -> Void){
    let value: Dictionary<String,Any> = [
      "uid": uid,
      "message": message,
      "timeStamp": ServerValue.timestamp()
    ]
    ref.child("chatrooms").child(chatRoomUid).child("comments").childByAutoId().setValue(value)
    completion()
  }
  
}



// 보내는 주체가 상대방의 fcm토큰을 알아서 거기에 메세지를 요청한다, 제목은 보내는 사람의 아이디, 내용은 텍스트
