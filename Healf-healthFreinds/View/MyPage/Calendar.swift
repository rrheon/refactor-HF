//
//  CalendarViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/19/24.
//

import FSCalendar

extension MypageViewController: FSCalendarDataSource, FSCalendarDelegate {
  // 공식 문서에서 레이아우울을 위해 아래의 코드 요구
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    calendar.snp.updateConstraints { (make) in
      make.height.equalTo(bounds.height)
      // Do other updates
    }
    self.view.layoutIfNeeded()
  }
  
  // 오늘 cell에 subtitle 생성
  func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    switch dateFormatter.string(from: date) {
    case dateFormatter.string(from: Date()):
      return "오늘"
      
    default:
      return nil
      
    }
  }
  
  // MARK: - 날짜 표시 매서드
  func calendar(_ calendar: FSCalendar,
                willDisplay cell: FSCalendarCell,
                for date: Date,
                at monthPosition: FSCalendarMonthPosition) {
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    
    // 날짜 배열에 포함되는지 확인
    if let day = components.day, highlightedDates.contains(day) {
      cell.titleLabel?.textColor = .white
      cell.shapeLayer?.path = UIBezierPath(ovalIn: cell.bounds).cgPath
      cell.shapeLayer?.fillColor = UIColor.mainBlue.cgColor
    } else {
      cell.titleLabel?.textColor = .black
    }
  }
  
  // MARK: - 날짜 선택 시 매서드
//   이전에 선택되어 있던 날짜가 하이라이트 배열에 포함되어 있으면 색상 설정되도록 수정하기
  func calendar(_ calendar: FSCalendar,
                didDeselect date: Date,
                at monthPosition: FSCalendarMonthPosition) {
    guard let cell = calendar.cell(for: date, at: monthPosition) else { return }
    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
    
    // 선택 해제된 날짜가 강조 대상 날짜인 경우, 강조 스타일을 다시 적용
    if let day = components.day, highlightedDates.contains(day) {
      cell.titleLabel?.textColor = .white
      cell.shapeLayer?.path = UIBezierPath(ovalIn: cell.bounds).cgPath
      cell.shapeLayer?.fillColor = UIColor.mainBlue.cgColor
    }
  }
  
  func calendar(_ calendar: FSCalendar,
                didSelect date: Date,
                at monthPosition: FSCalendarMonthPosition) {
      guard let cell = calendar.cell(for: date, at: monthPosition) else { return }
      let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
      
      // 선택된 날짜가 강조 대상 날짜인 경우, 강조 스타일을 적용
      if let day = components.day, highlightedDates.contains(day) {
          cell.titleLabel?.textColor = .white
          cell.shapeLayer?.path = UIBezierPath(ovalIn: cell.bounds).cgPath
          cell.shapeLayer?.fillColor = UIColor.mainBlue.cgColor
      }
      
      guard let selectedDay = calendar.cell(for: date, at: .current)?.titleLabel.text else { return }
      mypageViewModel.getDailyHistory(selectedDay) { data in
          DispatchQueue.main.async {
              self.selectedDailyCell(selectedDay, data: data)
          }
      }
  }
}
