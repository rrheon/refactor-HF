//
//  ChatListViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import Foundation

import FirebaseDatabase

final class ChatListViewModel: CommonViewModel {
  func getLastMessage(_ chatRoomUid: String,
                      completion: @escaping (ChatModel.Comment?) -> Void) {
    ref.child("chatrooms").child(chatRoomUid).child("comments")
      .queryOrderedByKey()
      .queryLimited(toLast: 1)
      .observeSingleEvent(of: .value, with: { (snapshot) in
        guard let lastSnapshot = snapshot.children.allObjects.last as? DataSnapshot else {
          completion(nil)
          return
        }
        let lastComment = ChatModel.Comment(JSON: lastSnapshot.value as! [String: AnyObject])
        completion(lastComment)
      })
  }
  
  // MARK: - 채팅방 리스트 가져오기
  func getAllChatroomData(currentUserUID: String,
                          completion: @escaping ([(String, String, String)]) -> Void) {
    var chatroomData: [(String, String, String)] = []
    
    ref.child("chatrooms").observe(DataEventType.value, with: { (snapshot) in
      for child in snapshot.children {
        let roomSnapshot = child as! DataSnapshot
        var currentUserParticipated = false
        
        if let userDataSnapshot = roomSnapshot.childSnapshot(forPath: "UserData").children.allObjects as? [DataSnapshot] {
          for userSnapshot in userDataSnapshot {
            let userId = userSnapshot.key
            let userParticipated = userSnapshot.value as! Bool
            
            if userId == currentUserUID && userParticipated {
              currentUserParticipated = true
              break
            }
          }
          
          if currentUserParticipated {
            for userSnapshot in userDataSnapshot {
              let userId = userSnapshot.key
              let userParticipated = userSnapshot.value as! Bool
              
              if userParticipated && userId != currentUserUID {
                self.ref.child("UserData").child(userId).observeSingleEvent(of: .value, with: { (userSnapshot) in
                  if let userData = userSnapshot.value as? [String: Any] {
                    let nickname = userData["nickname"] as? String ?? "Unknown"
                    chatroomData.append((roomSnapshot.key, userId, nickname))
                    completion(chatroomData)
                  }
                })
              }
            }
          }
        }
      }
    })
  }
  
}
