//
//  HomeViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/17/24.
//

import Foundation

import FirebaseDatabase

final class HomeViewModel: CommonViewModel {
  var weeklyCompletion: [Bool] = []
  
  func fetchThisMonthData(completion: @escaping ([String: Any]) -> Void) {
    let startDate = getStartDate()
    // 년도 -> 월 -> 선택한 날짜의 데이터만 뽑기
    ref.child("History").child(uid!).child(startDate[0]).child(startDate[1]).observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        print("Failed to load posts")
        return
      }
      print(value)
      completion(value)
    }
  }
  
  func convertToHistoryModel(for date: String, data: [String: Any]) -> HistoryModel? {
    guard let dataForDate = data[date] as? [String: Any] else { return nil }
    
    let comment = dataForDate["comment"] as? String ?? ""
    let date = dataForDate["date"] as? String ?? ""
    let rate = dataForDate["rate"] as? Double ?? 0.0
    let together = dataForDate["together"] as? String ?? ""
    let workoutTypes = dataForDate["workoutTypes"] as? [String] ?? []
    
    return HistoryModel(comment: comment, date: date, rate: rate,
                        together: together, workoutTypes: workoutTypes)
  }
  
  func getWorkoutData(completion: @escaping (([HistoryModel]) -> Void)) {
    let startDate = getStartDate()
    var workoutDatas: [HistoryModel] = []
    
    self.fetchThisMonthData { value in
      for dayOffset in 0..<7 {
        let currentDay = (Int(startDate[2]) ?? 0) + dayOffset
        if let workoutData = self.convertToHistoryModel(for: "\(currentDay)", data: value) {
          print("\(currentDay)일 데이터: \(workoutData.comment), \(workoutData.date), \(workoutData.rate), \(workoutData.together), \(workoutData.workoutTypes)")
          self.weeklyCompletion.append(true)
          workoutDatas.append(workoutData)
        } else { self.weeklyCompletion.append(false) }
      }
      completion(workoutDatas)
    }
  }
  
  func getHomeVCData(completion: @escaping ((Int, Double, Int)) -> Void) {
    var workoutCount: Int = 0
    var weeklyRate: Double = 0
    var together: Int = 0
    
    getWorkoutData { workoutDatas in
      workoutCount = workoutDatas.count
      workoutDatas.map { workoutData in
        if workoutData.together != "혼자 했어요" { together += 1 }
        weeklyRate += workoutData.rate
      }
    
      weeklyRate = weeklyRate/Double(workoutCount)
      
      let digit: Double = pow(10, 2)
      completion((workoutCount, round(weeklyRate * digit) / digit, together))
    }
  }
}
