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
  
  func fetchThisMonthData(completion: @escaping ([String: Any]?) -> Void) {
    let startDate = getStartDate()
    // 년도 -> 월 -> 선택한 날짜의 데이터만 뽑기
    ref.child("History").child(uid!).child(startDate[0]).child(startDate[1]).observeSingleEvent(of: .value) { snapshot in
      if let value = snapshot.value as? [String: Any] {
        completion(value)
      } else {
        completion(nil)
      }
    }
  }
  
  
  func convertToHistoryModelWithDate(for date: String,
                                     data: [String: Any]) -> HistoryModel? {
    guard let dataForDate = data[date] as? [String: Any] else { return nil }
    
    let comment = dataForDate["comment"] as? String ?? ""
    let date = dataForDate["date"] as? String ?? ""
    let rate = dataForDate["rate"] as? Double ?? 0.0
    let together = dataForDate["together"] as? String ?? ""
    let workoutTypes = dataForDate["workoutTypes"] as? [String] ?? []
    
    return HistoryModel(comment: comment, date: date, rate: rate,
                        together: together, workoutTypes: workoutTypes)
  }
  
  func convertToHistoryModel(data: [String: Any]) -> HistoryModel? {
    // 데이터에서 필요한 정보 추출
    let comment = data["comment"] as? String ?? ""
    let date = data["date"] as? String ?? ""
    let rate = data["rate"] as? Double ?? 0.0
    let together = data["together"] as? String ?? ""
    
    // workoutTypes가 NSArray 형식이므로 변환 필요
    let workoutTypesArray = data["workoutTypes"] as? NSArray ?? []
    let workoutTypes = workoutTypesArray.compactMap { $0 as? String }
    
    // HistoryModel 객체 생성하여 반환
    return HistoryModel(comment: comment, date: date, rate: rate,
                        together: together, workoutTypes: workoutTypes)
  }
  
  func convertUserModel(data: [String: Any]) -> UserModel? {
    let nickname = data["nickname"] as? String ?? ""
    let uid = data["uid"] as? String ?? ""
    let profileImageUrl = data["profileImageURL"] as? String ?? ""
    let togetherCount = data["togetherCount"] as? Int ?? 0
    let workoutCount = data["workoutCount"] as? Int ?? 0
    let postCount = data["postCount"] as? Int ?? 0
    let introduce = data["introduce"] as? String ?? ""
    let location = data["location"] as? String ?? ""
    
    // HistoryModel 객체 생성하여 반환
    return UserModel(nickname: nickname, uid: uid, profileImageURL: profileImageUrl,
                     togetherCount: togetherCount, workoutCount: workoutCount,
                     postCount: postCount, location: location, introduce: introduce)
    
  }
  
  func updateCount(childType: String, checkCraete: Bool = true){
    let ref = Database.database().reference().child("UserDataInfo").child(uid ?? "").child("\(childType)")
    
    ref.observeSingleEvent(of: .value) { snapshot in
      if var count = snapshot.value as? Int {
        count = checkCraete ? count + 1 : count - 1
        ref.setValue(count)
      } else {
        ref.setValue(1)
      }
    }
    
  }
}
