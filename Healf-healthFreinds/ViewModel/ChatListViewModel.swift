//
//  ChatListViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ObjectMapper

final class ChatListViewModel {
  
  func getChatListData(currentUserUID: String, completion: @escaping (String, String) -> Void){
    // 자기자신 빼기, 비어있을 경우 모두 출력되는 오류
    Database.database().reference().child("chatrooms").observe(DataEventType.value, with: { (snapshot) in
      var currentUserParticipated = false // 현재 사용자가 참여한 채팅방인지 여부를 나타내는 변수
      
      for child in snapshot.children {
        let roomSnapshot = child as! DataSnapshot
        
        // 각 채팅방의 UserData 노드에 접근하여 사용자 UID 가져오기
        if let userDataSnapshot = roomSnapshot.childSnapshot(forPath: "UserData").children.allObjects as? [DataSnapshot] {
          // 현재 사용자의 UID와 관련된 채팅방인지 확인
          for userSnapshot in userDataSnapshot {
            let userId = userSnapshot.key
            let userParticipated = userSnapshot.value as! Bool
            
            if userId == currentUserUID && userParticipated {
              currentUserParticipated = true
              break
            }
          }
          
          // 채팅방이 하나라도 있을 경우에만 사용자 정보를 가져옴
          if currentUserParticipated {
            for userSnapshot in userDataSnapshot {
              let userId = userSnapshot.key
              let userParticipated = userSnapshot.value as! Bool
              if userParticipated && userId != currentUserUID {
                // 사용자의 UID를 키로 사용하여 닉네임 가져오기
                Database.database()
                  .reference()
                  .child("UserData")
                  .child(userId)
                  .observeSingleEvent(of: .value, with: { (userSnapshot) in
                  if let userData = userSnapshot.value as? [String: Any] {
                    let nickname = userData["nickname"] as? String ?? "Unknown"
                    completion(userId, nickname)
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
