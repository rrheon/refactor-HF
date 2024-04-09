//
//  MypageViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit
import FSCalendar
import Kingfisher

// 값이 들어올 때 setuplayout, makeui 가 되도록 rx적용하기
protocol ImageSelectionDelegate: AnyObject {
  func didSelectImage(image: UIImage, introduce: String )
}

final class MypageViewController: NaviHelper {
  let uiHelper = UIHelper.shared
  
  private lazy var userNickNameLabel = uiHelper.createSingleLineLabel("Gildong.Hong")
  private lazy var userProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var userIntroduceLabel = uiHelper.createSingleLineLabel("소개")
  
  private lazy var matchingCountLabel = uiHelper.createMultipleLineLabel("매칭 횟수\n6번")
  private lazy var workoutCountLabel = uiHelper.createMultipleLineLabel("운동횟수\n6번")
  private lazy var postedCountLabel = uiHelper.createMultipleLineLabel("작성한 글\n6개")
  private lazy var userInfoStackView = uiHelper.createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var userProfileChangeButton = uiHelper.createHealfButton(" 프로필 편집 ", .mainBlue, .white)
  
  private lazy var userWorkoutCalenderButton = uiHelper.createButtonWithImage("","SeletedCalenderImg")
  private lazy var userPostedButton = uiHelper.createButtonWithImage("","MypostImg")
  
  private lazy var myPostColletionView = uiHelper.createCollectionView(scrollDirection: .vertical,
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
    //    calendar.locale = Locale(identifier: "ko_KR")
    
    // 현재 달의 날짜들만 표기하도록 설정
    calendar.placeholderType = .none
    
    // 헤더뷰 설정
    calendar.headerHeight = 55
    calendar.appearance.headerDateFormat = "YYYY.MM"
    calendar.appearance.headerTitleColor = .mainBlue
    
    // 요일 UI 설정
    calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
    calendar.appearance.weekdayTextColor = .black
    
    // 날짜 UI 설정
    calendar.appearance.titleTodayColor = .black
    calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
    calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 10)
    calendar.appearance.subtitleTodayColor = .mainBlue
    calendar.appearance.todayColor = .white
    
    calendar.layer.borderWidth = 1
    calendar.layer.cornerRadius = 15
    calendar.layer.borderColor = UIColor.unableGray.cgColor
    return calendar
  }()
  
  private lazy var selectedDayReportLabel = uiHelper.createMultipleLineLabel(selectedDayReportLabelTitle)
  
  let mypageViewModel = MypageViewModel()
  
  var selectedDayReportLabelTitle: String = "21일의 기록\n같이한 사람: test\n평점: 4.24\ncomment:good"
  var highlightedDates: [Int] = []
  var myPostDatas: [CreatePostModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    mypageViewModel.fectchMyPostData { self.myPostDatas = $0 }
    mypageViewModel.getMyWorkoutHistory { result in
      self.highlightedDates = result

      self.settingMyPageValue()

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
      userIntroduceLabel,
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
    
    scrollView.addSubview(myPostColletionView)
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
    
    userIntroduceLabel.snp.makeConstraints {
      $0.top.equalTo(userProfileImageView.snp.bottom).offset(10)
      $0.leading.equalTo(userProfileImageView)
    }
    
    userInfoStackView.backgroundColor = .clear
    userInfoStackView.snp.makeConstraints {
      $0.top.equalTo(userProfileImageView).offset(-10)
      $0.leading.equalTo(userProfileImageView.snp.trailing).offset(40)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    userProfileChangeButton.addAction(UIAction { _ in
      self.moveToEditProfileVC()
    }, for: .touchUpInside)
    userProfileChangeButton.snp.makeConstraints {
      $0.top.equalTo(userInfoStackView.snp.bottom)
      $0.leading.equalTo(userInfoStackView.snp.leading).offset(10)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    userWorkoutCalenderButton.addAction(UIAction { _ in
      self.calendarButtonTapped(self.userWorkoutCalenderButton)
    }, for: .touchUpInside)
    userWorkoutCalenderButton.snp.makeConstraints {
      $0.top.equalTo(userIntroduceLabel.snp.bottom).offset(30)
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
    
    myPostColletionView.isHidden = true
    myPostColletionView.snp.makeConstraints {
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
    myPostColletionView.delegate = self
    myPostColletionView.dataSource = self
    
    myPostColletionView.register(SearchResultCell.self,
                                       forCellWithReuseIdentifier: SearchResultCell.id)
  }
  
  // MARK: - calendarButtonTapped
  func calendarButtonTapped(_ sender: UIButton){
    let calendarButtonSelected = (sender == userWorkoutCalenderButton)
    
    let workoutImage = calendarButtonSelected ? "SeletedCalenderImg" : "CalenderImg"
    let postImage = calendarButtonSelected ? "MypostImg" : "SelectedPostImg"
    
    userWorkoutCalenderButton.setImage(UIImage(named: workoutImage), for: .normal)
    userPostedButton.setImage(UIImage(named: postImage), for: .normal)
    
    calendarView.isHidden = !calendarButtonSelected
    selectedDayReportLabel.isHidden = !calendarButtonSelected
    
    myPostColletionView.isHidden = calendarButtonSelected
    scrollView.isHidden = calendarButtonSelected
  }
  
  // MARK: - seletedDailyCell
  func selectedDailyCell(_ selectedDay: String, data: HistoryModel) {
    let noData = "❌ 해당 날짜의 기록이 존재하지 않습니다 ❌"
    let existedData = "\(selectedDay)일의 기록\n같이한 사람: \(data.together)\n평점: \(data.rate)\ncomment: \(data.comment)"
    selectedDayReportLabel.text = data.together == "기록없음" ? noData : existedData
  }
  
  // MARK: - settingMyPageValue
  func settingMyPageValue(){
    self.mypageViewModel.getMyInfomation { result in
      guard let togetherCount = result.togetherCount,
            let workoutCount = result.workoutCount,
            let postCount = result.postCount else { return }
      self.userNickNameLabel.text = result.nickname
      self.matchingCountLabel.text = "매칭 횟수\n\(togetherCount)번"
      self.workoutCountLabel.text = "운동 횟수\n\(workoutCount)번"
      self.postedCountLabel.text = "작성한 글\n\(postCount)개"
      self.userIntroduceLabel.text = result.introduce
      
      self.mypageViewModel.getUserProfileImage { result in
        DispatchQueue.main.async {
          switch result {
          case .success(let image):
            self.userProfileImageView.image = image
            self.userProfileImageView.layer.cornerRadius = 35
            self.userProfileImageView.clipsToBounds = true
          case .failure(let error):
            print("Failed to load user profile image: \(error)")
          }
        }
      }
    }
  }
  
  // MARK: - move to editVC
  func moveToEditProfileVC(){
    guard let profileImage = userProfileImageView.image,
          let introduce = userIntroduceLabel.text else { return }
    let editProfileVC = EditMyProfileViewController(delegate: self,
                                                    profileImage: profileImage,
                                                    introduce: introduce)
    navigationController?.pushViewController(editProfileVC, animated: true)
  }
}

// MARK: - collectionView
extension MypageViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return myPostDatas.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    moveToPostedVC(myPostDatas[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // 참여하기 버튼 없애기
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.id,
                                                  for: indexPath) as! SearchResultCell
    
    cell.configure(with: myPostDatas[indexPath.row], checkMyPost: true)
    cell.delegate = self
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 185)
  }
}

// MARK: - ImageSelectionDelegate
extension MypageViewController: ImageSelectionDelegate {
  func didSelectImage(image: UIImage, introduce: String) {
    userProfileImageView.image = image
    userProfileImageView.layer.cornerRadius = 35
    userProfileImageView.clipsToBounds = true
    
    userIntroduceLabel.text = introduce
  }
}

// MARK: - ParticipateButtonDelegate
extension MypageViewController: ParticipateButtonDelegate {
  func participateButtonTapped(postedData: CreatePostModel) {
    let bottomSheetVC = BottomSheet(firstButtonTitle: "게시글 삭제하기",
                                    secondButtonTitle: "게시글 수정하기",
                                    checkPost: true,
                                    postedData: postedData)
    bottomSheetVC.delegate = self
    
    uihelper.settingBottomeSheet(bottomSheetVC: bottomSheetVC, size: 220)
    present(bottomSheetVC, animated: true, completion: nil)
  }
}

extension MypageViewController: BottomSheetDelegate {
  func firstButtonTapped(_ postedData: CreatePostModel?) {
    guard let postedDate = postedData?.postedDate,
          let postedInfo = postedData?.info else { return }
    mypageViewModel.deleteMyPost(postedDate: postedDate, info: postedInfo) {
      self.uiHelper.showToast(message: "✅ 게시글이 삭제되었습니다.")
      self.myPostColletionView.reloadData()
    }
  }
  
  func secondButtonTapped(_ postedData: CreatePostModel?) {
    print("2")
  }
}
