//
//  CalendarViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/19/24.
//

import UIKit

import FSCalendar
import SnapKit

class CalendarViewController: UIViewController {
  // delegate로 전달해보자
  private var calendar: FSCalendar?
  
  var selectedStatDate: String = ""
  var selectDate: String?
  var selectedDay: Int = 0
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월" // 원하는 날짜 형식으로 설정
    return formatter
  }()
  
  var buttonSelect: Bool?
  private lazy var titleLabel = UIHelper.shared.createSingleLineLabel("test")
  
  private lazy var previousButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate),
                    for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(self.prevCurrentPage), for: .touchUpInside)
    return button
  }()
  
  // 다음 주 이동 버튼
  private lazy var nextButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate),
                    for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(self.nextCurrentPage), for: .touchUpInside)
    return button
  }()
  
  private lazy var completeButton: UIButton = {
    let button = UIButton()
    button.setTitle("완료", for: .normal)
    button.setTitleColor(.black, for: .normal)  // 텍스트 색상을 변경합니다.
    button.addTarget(self, action: #selector(self.completeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private let today: Date = {
    return Date()
  }()
  
  private var currentPage: Date?
  
  var selectedDate: Date? = Date()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    calendar?.locale = Locale(identifier: "ko_KR")
    
    setupLayout()
    setupCalendarUI()
    
    view.backgroundColor = .white
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    let endIndex = selectedStatDate.index(selectedStatDate.endIndex, offsetBy: -2)
    selectedDay = Int(selectedStatDate[endIndex...]) ?? 0
    
    calendar = FSCalendar(frame: .zero)
    
    if let cal = calendar {
      view.addSubview(cal)
      cal.snp.makeConstraints { make in
        make.top.equalTo(view.snp.top).offset(100)
        make.leading.trailing.bottom.equalTo(view)
      }
    }
    
    view.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(calendar!).offset(50)
      make.top.equalTo(calendar!).offset(-60)
    }
    
    view.addSubview(previousButton)
    previousButton.snp.makeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.trailing.equalTo(titleLabel.snp.leading).offset(-20)
    }
    
    view.addSubview(nextButton)
    // nextButton 제약 설정
    nextButton.snp.makeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.leading.equalTo(titleLabel.snp.trailing).offset(20)
    }
    
    view.addSubview(completeButton)
    completeButton.snp.makeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
    }
  }
  
  // MARK: - setupCalendarUI
  func setupCalendarUI() {
    calendar?.allowsSelection = true
    calendar?.allowsMultipleSelection = false
    
    calendar?.delegate = self
    calendar?.dataSource = self
    
    calendar?.scrollEnabled = false
    
    // 상단 요일을 한글로 변경
    self.calendar?.calendarWeekdayView.weekdayLabels[0].text = "일"
    self.calendar?.calendarWeekdayView.weekdayLabels[1].text = "월"
    self.calendar?.calendarWeekdayView.weekdayLabels[2].text = "화"
    self.calendar?.calendarWeekdayView.weekdayLabels[3].text = "수"
    self.calendar?.calendarWeekdayView.weekdayLabels[4].text = "목"
    self.calendar?.calendarWeekdayView.weekdayLabels[5].text = "금"
    self.calendar?.calendarWeekdayView.weekdayLabels[6].text = "토"
    
    calendar?.headerHeight = 0
    
    // 숫자들 글자 폰트 및 사이즈 지정
    calendar?.appearance.titleFont = UIFont(name: "Pretendare-Medium", size: 14)
    
    
    // 양옆 년도, 월 지우기
    calendar?.appearance.headerMinimumDissolvedAlpha = 0.0
    // 달에 유효하지 않은 날짜의 색 지정
    self.calendar?.appearance.titlePlaceholderColor = UIColor.red.withAlphaComponent(0.2)
    // 평일 날짜 색
    self.calendar?.appearance.titleDefaultColor = UIColor.black.withAlphaComponent(0.8)
    self.calendar?.placeholderType = .none
    
    calendar?.appearance.titlePlaceholderColor = .lightGray
    
    
    calendar?.reloadData()
  }
  
  func calendar(_ calendar: FSCalendar,
                willDisplay cell: FSCalendarCell,
                for date: Date,
                at monthPosition: FSCalendarMonthPosition) {
    let calendarCurrent = Calendar.current
    let currentMonth = calendarCurrent.component(.month, from: Date())
    let cellMonth = calendarCurrent.component(.month, from: date)
    
    if cellMonth == currentMonth {
      let currentDay = calendarCurrent.component(.day, from: Date())
      let cellDay = calendarCurrent.component(.day, from: date)
      }
    }
  
  
  // MARK: - 날짜 선택 시 콜백 메소드
  public func calendar(_ calendar: FSCalendar,
                       didSelect date: Date,
                       at monthPosition: FSCalendarMonthPosition) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    selectDate = dateFormatter.string(from: date)
    
    let isToday = Calendar.current.isDate(date, inSameDayAs: Date())
    
    
    if !isToday {
      calendar.appearance.todayColor = .white
      calendar.appearance.titleTodayColor = .black
    } else if isToday{
      calendar.appearance.todayColor = nil
    }

    calendar.appearance.selectionColor = .mainBlue
  }
  
  @objc private func nextCurrentPage(_ sender: UIButton) {
    let cal = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.month = 1
    dateFormatter.dateFormat = "yyyy년 MM월"
    
    self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today )
    if let currentPage = self.currentPage {
      self.calendar?.setCurrentPage(currentPage, animated: true)
    }
  }
  
  @objc private func prevCurrentPage(_ sender: UIButton) {
    let cal = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.month = -1
    dateFormatter.dateFormat = "yyyy년 MM월"
    
    self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today )
    if let currentPage = self.currentPage {
      self.calendar?.setCurrentPage(currentPage, animated: true)
    }
  }


  
  @objc private func completeButtonTapped(_ sender: UIButton) {
    if selectedDate == nil {
      selectedDate = self.today
    }
    guard let data = selectDate else { return }
    
    self.dismiss(animated: true, completion: nil)
  }
}

extension Date {
  static func today() -> Date {
    return Date()
  }
}

extension CalendarViewController: FSCalendarDelegate,
                                  FSCalendarDataSource,
                                  FSCalendarDelegateAppearance {
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    self.titleLabel.text = self.dateFormatter.string(from: calendar.currentPage)
  }
  
  // 현재 날짜를 선택할 수 있는지 여부
  func calendar(_ calendar: FSCalendar,
                shouldSelect date: Date,
                at monthPosition: FSCalendarMonthPosition) -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let test = dateFormatter.date(from: selectedStatDate){
      if date < test && buttonSelect == false {
        return false
      }
    }
    
    if calendar.isDate(date, inSameDayAs: currentDate) {
      return true
    }
    
    return date > currentDate
  }
  
  
  // 기본 색상 설정
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
    let currentDate = Date()
    let calendar = Calendar.current
    
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let startDate = dateFormatter.date(from: selectedStatDate),
       date < startDate && buttonSelect == false {
      return UIColor.black
    }
    
    if calendar.isDate(date, inSameDayAs: currentDate) || date > currentDate {
      return appearance.titleDefaultColor
    } else {
      return UIColor.black
    }
  }
}
