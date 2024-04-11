//
//  CalendarViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/19/24.
//

import FSCalendar

class FSCalendarCustom: FSCalendar {
  static let shared = FSCalendarCustom()
  let myPageViewModel = MypageViewModel.shared
  let commonViewModel = CommonViewModel.sharedCommonViewModel
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    self.firstWeekday = 2
    self.scope = .month
    self.scrollEnabled = false
    self.placeholderType = .none
    self.headerHeight = 55
    self.appearance.headerDateFormat = "YYYY.MM"
    self.appearance.headerTitleColor = .mainBlue
    self.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
    self.appearance.weekdayTextColor = .black
    self.appearance.titleTodayColor = .black
    self.appearance.titleFont = UIFont.systemFont(ofSize: 16)
    self.appearance.subtitleFont = UIFont.systemFont(ofSize: 10)
    self.appearance.subtitleTodayColor = .mainBlue
    self.appearance.todayColor = .white
    
    self.layer.borderWidth = 1
    self.layer.cornerRadius = 15
    self.layer.borderColor = UIColor.unableGray.cgColor
  }
  
  func createButton(image: String) -> UIButton {
    let button = UIButton()
    button.setImage(UIImage(named: image), for: .normal)
    return button
  }
  
  func moveMonth(next: Bool, completion: @escaping ([Int]) -> Void) {
    let koreaTimeZone = TimeZone(identifier: "Asia/Seoul")!
    var koreaCalendar = Calendar.current
    koreaCalendar.timeZone = koreaTimeZone
    
    var dateComponents = DateComponents()
    dateComponents.month = next ? 1 : -1
    
    if let newPageDate = koreaCalendar.date(byAdding: dateComponents, to: self.currentPage) {
      self.currentPage = newPageDate
      self.setCurrentPage(newPageDate, animated: true)
      
      let (year, month) = commonViewModel.getKoreanYearAndMonth(from: newPageDate)
      
      print("년도: \(year), 월: \(month)")
      myPageViewModel.getMyWorkoutHistory(checkMoveMonth: true,
                                          year: year,
                                          month: month) { result in
        completion(result)
      }
    }
  }
}

extension MypageViewController: FSCalendarDataSource, FSCalendarDelegate {
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    calendar.snp.updateConstraints { (make) in
      make.height.equalTo(bounds.height)
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
    
    if let day = components.day, highlightedDates.contains(day) {
      cell.titleLabel?.textColor = .white
      cell.shapeLayer?.path = UIBezierPath(ovalIn: cell.bounds).cgPath
      cell.shapeLayer?.fillColor = UIColor.mainBlue.cgColor
    }
    
    guard let selectedDay = calendar.cell(for: date, at: .current)?.titleLabel.text else { return }
    
    let koreaTimeZone = TimeZone(identifier: "Asia/Seoul")!
    var koreaCalendar = Calendar.current
    koreaCalendar.timeZone = koreaTimeZone
    
    let (year,month) = commonViewModel.getKoreanYearAndMonth(from: date)
  
    let currentDate = commonViewModel.getCurrentDate()
    
    mypageViewModel.getDailyHistory(checkOtherMonth: true,
                                    year: year, month: month, selectedDay) { data in
      DispatchQueue.main.async {
        self.selectedDailyCell(selectedDay, data: data)
      }
    }
  }
}
