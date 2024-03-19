//
//  CommonViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/14/24.
//

import Foundation

import FirebaseAuth
import FirebaseDatabase

class CommonViewModel {
  let uid = Auth.auth().currentUser?.uid
  let ref = Database.database().reference()
  
  func getCurrentDate() -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: currentDate)
  }
  
  func getCurrentYearMonthAndDay() -> (Int, Int, Int) {
    let currentDate = Date()
    let calendar = Calendar.current
    let year = calendar.component(.year, from: currentDate)
    let month = calendar.component(.month, from: currentDate)
    let day = calendar.component(.day, from: currentDate)
    return (year, month, day)
  }
  
  func getStartDate() -> [String] {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-M-dd-e-EEEE"  // 년도와 e는 1~7(sun~sat)
    
    let day = formatter.string(from: Date())
    let today = day.components(separatedBy: "-")
    // [0] = yyyy, [1] = MMM, [2] = dd, [3] = e(1), [4] = EEEE(Sunday)
    
    // e(요일)을 정수로 변환
    guard let weekday = Int(today[3].trimmingCharacters(in: .whitespaces)),
          weekday >= 1 && weekday <= 7 else { return [] }
    var interval = Double(weekday - 2) // 일요일을 기준으로 이전 주의 시작 요일까지의 간격
    
    // 현재 요일이 일요일인 경우에는 주의 시작 요일을 앞당겨야 함
    if weekday == 1 { interval += 6 }
    
    // 현재 날짜를 기준으로 이전 주의 시작 날짜 계산
    let calendar = Calendar(identifier: .gregorian)
    let startDay = calendar.date(byAdding: .day, value: -Int(interval), to: Date()) ?? Date()
    
    let startDayString = formatter.string(from: startDay).components(separatedBy: "-")
    return startDayString
  }
}
