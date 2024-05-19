//
//  HomeViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/17/24.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeViewModel: CommonViewModel {
  static let shared = HomeViewModel()
  
  lazy var startDate = getStartDate()
  lazy var montlyDatasObservable = BehaviorRelay<[String: Any]?>(value: nil)
  
  lazy var weeklyCompletionDatas: Observable<[Bool]> = {
    return montlyDatasObservable.map { data in
      guard let data = data else { return [Bool]() }
      
      return (0..<7).map { dayOffset in
        let currentDay = (Int(self.startDate[2]) ?? 0) + dayOffset - 1
        return self.convertToHistoryModelWithDate(for: "\(currentDay)", data: data) != nil
      }
    }
  }()
  
  lazy var weeklyDatas = montlyDatasObservable.map { data -> [HistoryModel] in
      guard let data = data else { return [] }
      
      return (0..<7).compactMap { dayOffset in
        let currentDay = (Int(self.startDate[2]) ?? 0) + dayOffset
        return self.convertToHistoryModelWithDate(for: "\(currentDay)", data: data)
      }
    }
  
  lazy var weeklySummaryDatas = weeklyDatas.map { weeklyDatas in
    let digit: Double = pow(10, 2)
    let workoutCount = weeklyDatas.count
    let together = weeklyDatas.filter { $0.together != "혼자 했어요" }.count
    let weeklyRate = workoutCount == 0 ? 0.0 : weeklyDatas.reduce(0.0) { $0 + $1.rate } / Double(workoutCount)
    
    return (workoutCount, round(weeklyRate * digit) / digit, together)
  }
  
  override init() {
    super.init()
    self.updateMontlyDatas()
  }
  
  // 새로운 데이터를 가져오는 함수
  func updateMontlyDatas() {
    fetchThisMonthData()
      .subscribe(onNext: { [weak self] newData in
        self?.montlyDatasObservable.accept(newData)
      })
      .disposed(by: disposeBag)
  }
}
