//
//  MypageViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/21/24.
//

import Foundation

class MypageViewModel: CommonViewModel {
  // 받아와야할 것 - 1.해당 월 전체(데이터 있으면 표시 없으면 냅두기), 2. 선택한 날짜의 데이터 뿌려주기
  func getMyInfomation(completion: @escaping(UserModel) -> Void){
    ref.child("UserData").child(uid ?? "").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else { return }
      guard let userData = self.convertUserModel(data: value) else { return}
      completion(userData)
    }
  }

  func fetchDailyData(_ selectedDay: String,
                      completion: @escaping ([String: Any]) -> Void) {
    let startDate = getStartDate()
    // 년도 -> 월 -> 선택한 날짜의 데이터만 뽑기
    ref.child("History").child(uid!).child(startDate[0]).child(startDate[1]).child(selectedDay)
      .observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        print("Failed to load posts")
        return
      }
      completion(value)
    }
  }
  
  func getMyWorkoutHistory(completion: @escaping (([Int]) -> Void)){
    var monthlyWorkoutCheck: [Int] = []
    fetchThisMonthData { monthlyData in
      for dayOffset in 1..<31 {
        if let workoutData = self.convertToHistoryModelWithDate(for: "\(dayOffset)",
                                                                data: monthlyData) {
          monthlyWorkoutCheck.append(dayOffset)
        }
      }
      completion(monthlyWorkoutCheck)
    }
  }
  
  func getDailyHistory(_ selectedDay: String, completion: @escaping (HistoryModel) -> Void) {
    fetchDailyData(selectedDay) { result in
      guard let workoutData = self.convertToHistoryModel(data: result) else {return }
      completion(workoutData)
    }
  }
}
