//
//  MypageViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/21/24.
//

import Foundation

class MypageViewModel: CommonViewModel {
  // 받아와야할 것 - 해당 월 전체(데이터 있으면 표시 없으면 냅두기), 선택한 날짜의 데이터 뿌려주기
  
  func fetchThisMonthData(completion: @escaping ([String: Any]) -> Void) {
    let startDate = getStartDate()
    // 년도 -> 월 -> 선택한 날짜의 데이터만 뽑기
    ref.child("History").child(uid!).child(startDate[0]).child(startDate[1]).observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        print("Failed to load posts")
        return
      }
      completion(value)
    }
  }
  
}
