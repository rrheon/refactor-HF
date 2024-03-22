//
//  WriteHistoryViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/14/24.
//

import Foundation

import FirebaseAuth
import FirebaseDatabase

final class WriteHistoryViewModel: CommonViewModel {
  // 기존 db에 데이터 추가
  //    ref.child("UserData").child(uid ?? "").child("testKey").setValue("testValue") { (error, ref) in
  //        if let error = error {
  //            print("Error adding new key: \(error.localizedDescription)")
  //        } else {
  //            print("New key added successfully!")
  //        }
  //    }
  func createPost(_ together: String,
                  _ rate: Double,
                  _ workoutTyes: [String],
                  _ comment: String,
                  vc: WriteHistoryViewController){
    guard let uid = uid else { return }
    
    let currentDate = getCurrentDate()
    
    let userHistory = [
      "together": together, // 같이 -> 유저의 닉네임, 혼자 -> alone
      "rate": rate, // 평점
      "workoutTypes": workoutTyes, // 운동 종류
      "comment": comment,
      "date": currentDate // 오늘의 날짜
    ] as [String : Any]
    
    let splitDate = getCurrentYearMonthAndDay()
    
    self.ref.child("History").child(uid)
      .child("\(splitDate.0)").child("\(splitDate.1)").child("\(splitDate.2)").setValue(userHistory)
    
    if together != "혼자 했어요"{ updateCount(childType: "togetherCount") }
    
    updateCount(childType: "workoutCount")
    
    vc.popupVC()
    
  }
}
