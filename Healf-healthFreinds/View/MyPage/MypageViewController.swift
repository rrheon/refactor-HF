//
//  MypageViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit
import FSCalendar

final class MypageViewController: NaviHelper {
  let uiHelper = UIHelper.shared
  
  private lazy var userNickNameLabel = uiHelper.createSingleLineLabel("Gildong.Hong")
  private lazy var userProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  
  private lazy var matchingCountLabel = uiHelper.createMultipleLineLabel("매칭 횟수\n6번")
  private lazy var workoutCountLabel = uiHelper.createMultipleLineLabel("운동횟수\n6번")
  private lazy var postedCountLabel = uiHelper.createMultipleLineLabel("작성한 글\n6개")
  private lazy var userInfoStackView = uiHelper.createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var userProfileChangeButton = uiHelper.createHealfButton(" 프로필 편집 ", .mainBlue, .white)
  
  private lazy var userWorkoutCalenderButton = uiHelper.createButtonWithImage("","SeletedCalenderImg")
  private lazy var userPostedButton = uiHelper.createButtonWithImage("","MypostImg")
  
  private lazy var userWorkoutCollectionView = uiHelper.createCollectionView(scrollDirection: .vertical,
                                                                             spacing: 20)
  private let scrollView = UIScrollView()
  
  private lazy var calendarView: FSCalendar = {
    let calendar = FSCalendar()
    calendar.dataSource = self
    calendar.delegate = self
    calendar.firstWeekday = 2
    // week 또는 month 가능
    calendar.scope = .month
    
    calendar.scrollEnabled = false
    calendar.locale = Locale(identifier: "ko_KR")
    
    // 현재 달의 날짜들만 표기하도록 설정
    calendar.placeholderType = .none
    
    // 헤더뷰 설정
    calendar.headerHeight = 55
    calendar.appearance.headerDateFormat = "YYYY년-MM월"
    calendar.appearance.headerTitleColor = .black
    
    // 요일 UI 설정
    calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
    calendar.appearance.weekdayTextColor = .black
    
    // 날짜 UI 설정
    calendar.appearance.titleTodayColor = .black
    calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
    calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 10)
    calendar.appearance.subtitleTodayColor = .mainBlue
    calendar.appearance.todayColor = .white
    
    
    // 일요일 라벨의 textColor를 red로 설정
    calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .red
    
    calendar.layer.borderWidth = 1
    calendar.layer.cornerRadius = 15
    calendar.layer.borderColor = UIColor.unableGray.cgColor
    
    return calendar
  }()
  
  var selectedDayReportLabelTitle: String = "21일의 기록\n같이한 사람: test\n평점: 4.24\ncomment:good"
  private lazy var selectedDayReportLabel = uiHelper.createMultipleLineLabel(selectedDayReportLabelTitle)

  var highlightedDates: [Int] = []

  let mypageViewModel = MypageViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    mypageViewModel.getMyWorkoutHistory { result in
      self.highlightedDates = result
      self.setupLayout()
      self.makeUI()
      
      self.registerCell()
    }
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      matchingCountLabel,
      workoutCountLabel,
      postedCountLabel
    ].forEach {
      userInfoStackView.addArrangedSubview($0)
    }
        
    [
      userNickNameLabel,
      userProfileImageView,
      userInfoStackView,
      userProfileChangeButton,
      userWorkoutCalenderButton,
      userPostedButton,
      calendarView,
      selectedDayReportLabel,
      scrollView
    ].forEach {
      view.addSubview($0)
    }
    
    scrollView.addSubview(userWorkoutCollectionView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    userNickNameLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(20)
    }
    
    userProfileImageView.snp.makeConstraints {
      $0.top.equalTo(userNickNameLabel.snp.bottom).offset(10)
      $0.leading.equalTo(userNickNameLabel)
      $0.height.width.equalTo(80)
    }
    
    userInfoStackView.backgroundColor = .clear
    userInfoStackView.snp.makeConstraints {
      $0.top.equalTo(userProfileImageView).offset(-10)
      $0.leading.equalTo(userProfileImageView.snp.trailing).offset(40)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    userProfileChangeButton.snp.makeConstraints {
      $0.top.equalTo(userInfoStackView.snp.bottom)
      $0.leading.equalTo(userInfoStackView.snp.leading).offset(10)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    userWorkoutCalenderButton.addAction(UIAction { _ in
      self.calendarButtonTapped(self.userWorkoutCalenderButton)
    }, for: .touchUpInside)
    userWorkoutCalenderButton.snp.makeConstraints {
      $0.top.equalTo(userProfileChangeButton.snp.bottom).offset(30)
      $0.leading.equalTo(userProfileImageView).offset(70)
    }
    
    userPostedButton.addAction(UIAction { _ in
      self.calendarButtonTapped(self.userPostedButton)
    }, for: .touchUpInside)
    userPostedButton.snp.makeConstraints {
      $0.top.equalTo(userWorkoutCalenderButton)
      $0.leading.equalTo(userWorkoutCalenderButton.snp.trailing).offset(80)
    }
    
    calendarView.snp.makeConstraints {
      $0.top.equalTo(userWorkoutCalenderButton.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
      $0.height.equalTo(296)
    }
    
    selectedDayReportLabel.textAlignment = .left
    selectedDayReportLabel.snp.makeConstraints {
      $0.top.equalTo(calendarView.snp.bottom).offset(10)
      $0.leading.equalTo(calendarView)
    }
    
    userWorkoutCollectionView.isHidden = true
    userWorkoutCollectionView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(scrollView.snp.height)
    }
    
    scrollView.isHidden = true
    scrollView.snp.makeConstraints {
      $0.top.equalTo(userWorkoutCalenderButton.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalTo(view)
    }
  }
  
  func registerCell(){
    userWorkoutCollectionView.delegate = self
    userWorkoutCollectionView.dataSource = self
    
    userWorkoutCollectionView.register(SearchResultCell.self,
                                  forCellWithReuseIdentifier: SearchResultCell.id)
  }
  
  func calendarButtonTapped(_ sender: UIButton){
    let calendarButtonSelected = (sender == userWorkoutCalenderButton)

    let workoutImage = calendarButtonSelected ? "SeletedCalenderImg" : "CalenderImg"
    let postImage = calendarButtonSelected ? "MypostImg" : "SelectedPostImg"

    userWorkoutCalenderButton.setImage(UIImage(named: workoutImage), for: .normal)
    userPostedButton.setImage(UIImage(named: postImage), for: .normal)

    calendarView.isHidden = !calendarButtonSelected
    selectedDayReportLabel.isHidden = !calendarButtonSelected
    
    userWorkoutCollectionView.isHidden = calendarButtonSelected
    scrollView.isHidden = calendarButtonSelected
  }
}

// MARK: - collectionView
extension MypageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let postedVC = PostedViewController()
    postedVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(postedVC, animated: true)

  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // 참여하기 버튼 없애기
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.id,
                                                  for: indexPath) as! SearchResultCell
  
    
    return cell
  }
}

// 셀의 각각의 크기
extension MypageViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 185)
  }
}

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
  
  // 일요일에 해당되는 모든 날짜의 색상 red로 변경
  func calendar(_ calendar: FSCalendar,
                appearance: FSCalendarAppearance,
                titleDefaultColorFor date: Date) -> UIColor? {
    let day = Calendar.current.component(.weekday, from: date) - 1
    
    if Calendar.current.shortWeekdaySymbols[day] == "일" {
      return .systemRed
    } else {
      return .label
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

  func selectedDailyCell(_ selectedDay: String, data: HistoryModel) {
      self.selectedDayReportLabel.text = "\(selectedDay)의 기록\n같이한 사람: \(data.together)\n평점: \(data.rate)\ncomment: \(data.comment)"
  }

}
