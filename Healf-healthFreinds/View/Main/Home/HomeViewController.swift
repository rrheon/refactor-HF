//
//  HomeViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2/28/24.
//

import UIKit

import SnapKit

final class HomeViewController: NaviHelper {
  
  private lazy var topUnderLineView = UIView()
  
  private lazy var mainImageView = UIImageView(image: UIImage(named: "HomeMainImg"))
  private lazy var weeklySummaryDataLabel = UIHelper.shared.createSingleLineLabel("주간 요약 📊")
  private lazy var weeklySummaryStackView = UIHelper.shared.createStackView(axis: .horizontal,
                                                                            spacing: 5)
  private lazy var timeCountLabel = UIHelper.shared.createMultipleLineLabel("운동 횟수\n3회")
  private lazy var timeSummaryLabel = UIHelper.shared.createMultipleLineLabel("운동 시간\n8시간 30분")
  private lazy var withFriendsLabel = UIHelper.shared.createMultipleLineLabel("함께한 친구\n3명")
  private lazy var rightTimeCountView = UIView()
  private lazy var rightTimeSummaryView = UIView()
  
  private lazy var weeklyCompleteLabel = UIHelper.shared.createSingleLineLabel("주간 달성률 🏆")
  private lazy var weeklyCompleteStackView = UIHelper.shared.createStackView(axis: .horizontal,
                                                                             spacing: 1,
                                                                             backgroundColor: .white)
  private lazy var mondayLabel = UIHelper.shared.createWeeklyCompleteLabel("월")
  private lazy var tuesdayLabel = UIHelper.shared.createWeeklyCompleteLabel("화")
  private lazy var wensdayLabel = UIHelper.shared.createWeeklyCompleteLabel("수")
  private lazy var thursayLabel = UIHelper.shared.createWeeklyCompleteLabel("목")
  private lazy var fridayLabel = UIHelper.shared.createWeeklyCompleteLabel("금")
  private lazy var satdayLabel = UIHelper.shared.createWeeklyCompleteLabel("토")
  private lazy var sundayLabel = UIHelper.shared.createWeeklyCompleteLabel("일")

  private lazy var newPostContentStackView = UIHelper.shared.createStackView(axis: .vertical,
                                                                             spacing: 10,
                                                                             backgroundColor: .white)
  private lazy var newPostTitleLabel = UIHelper.shared.createSingleLineLabel("New 매칭 🙌🏻")
  
  private lazy var postCollectionView = UIHelper.shared.createCollectionView(scrollDirection: .horizontal,
                                                                             spacing: 50)

  private lazy var startButton = UIHelper.shared.createHealfButton("💪🏻 운동 기록하기", .mainBlue, .white)
  private lazy var contentView = UIView()

  let homeViewModel = HomeViewModel()
  var weekLabels: [UILabel] = []
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    registerCell()
    
    setupLayout()
    makeUI()
    
    settingHomeVCDatas()
    
    changeLabelColor()
  }
  
  override func navigationItemSetting() {
    let logoImg = UIImage(named: "MainTitleImg")?.withRenderingMode(.alwaysOriginal)
    let logo = UIBarButtonItem(image: logoImg, style: .done, target: nil, action: nil)
    logo.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
    logo.isEnabled = false
    
    navigationItem.leftBarButtonItem = logo
  }
    
  // MARK: - setupLayout
  func setupLayout(){
    [
      timeCountLabel,
      rightTimeCountView,
      timeSummaryLabel,
      rightTimeSummaryView,
      withFriendsLabel
    ].forEach {
      weeklySummaryStackView.addArrangedSubview($0)
    }
    
    [
      mondayLabel,
      tuesdayLabel,
      wensdayLabel,
      thursayLabel,
      fridayLabel,
      satdayLabel,
      sundayLabel
    ].forEach {
      weeklyCompleteStackView.addArrangedSubview($0)
      weekLabels.append($0)
    }
   
    [
      newPostTitleLabel,
      postCollectionView
    ].forEach {
      newPostContentStackView.addArrangedSubview($0)
    }
    
    [
      mainImageView,
      weeklySummaryDataLabel,
      weeklySummaryStackView,
      weeklyCompleteLabel,
      weeklyCompleteStackView,
      newPostContentStackView,
      startButton
    ].forEach {
      contentView.addSubview($0)
    }
    
    view.addSubview(topUnderLineView)
    view.addSubview(contentView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    topUnderLineView.backgroundColor = .unableGray
    topUnderLineView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    mainImageView.snp.makeConstraints {
      $0.top.equalTo(topUnderLineView.snp.bottom)
      $0.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
      $0.height.equalTo(150)
    }
    
    weeklySummaryDataLabel.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom).offset(10)
      $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(30)
    }
    
    rightTimeCountView.backgroundColor = .lightGray
    rightTimeCountView.snp.makeConstraints {
      $0.width.equalTo(1)
      $0.height.equalTo(40)
    }
    
    rightTimeSummaryView.backgroundColor = .lightGray
    rightTimeSummaryView.snp.makeConstraints {
      $0.width.equalTo(1)
      $0.height.equalTo(40)
    }
    
    weeklySummaryStackView.alignment = .center
    weeklySummaryStackView.distribution = .equalCentering
    weeklySummaryStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    weeklySummaryStackView.snp.makeConstraints {
      $0.top.equalTo(weeklySummaryDataLabel.snp.bottom).offset(10)
      $0.leading.equalTo(weeklySummaryDataLabel)
      $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-30)
    }
    
    weeklyCompleteLabel.snp.makeConstraints {
      $0.top.equalTo(weeklySummaryStackView.snp.bottom).offset(10)
      $0.leading.equalTo(weeklySummaryStackView)
    }
    
    weeklyCompleteStackView.alignment = .center
    weeklyCompleteStackView.distribution = .fillEqually
    weeklyCompleteStackView.snp.makeConstraints {
      $0.top.equalTo(weeklyCompleteLabel.snp.bottom).offset(10)
      $0.leading.equalTo(weeklySummaryStackView.snp.leading).offset(-10)
      $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-20)
    }
    
    newPostContentStackView.snp.makeConstraints {
      $0.top.equalTo(weeklyCompleteStackView.snp.bottom)
      $0.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(30)
      $0.leading.equalTo(weeklyCompleteStackView.snp.leading)
    }

    postCollectionView.snp.makeConstraints {
      $0.top.equalTo(newPostTitleLabel.snp.bottom).offset(10)
      $0.height.equalTo(170)
    }

    startButton.addAction(UIAction { _ in
      self.startButtonTapped()
    }, for: .touchUpInside)
    startButton.snp.makeConstraints {
      $0.top.equalTo(newPostContentStackView.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(weeklySummaryStackView)
      $0.height.equalTo(50)
    }

    contentView.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.width.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func registerCell() {
    postCollectionView.delegate = self
    postCollectionView.dataSource = self
    
    postCollectionView.register(PostedCell.self, forCellWithReuseIdentifier: PostedCell.id)
  }
  
  // MARK: - changeLabelColor
  func changeLabelColor(){
    UIHelper.shared.changeColor(label: newPostTitleLabel,
                                wantToChange: "New",
                                color: .labelBlue)
  }
  
  // MARK: - startButtonTapped
  @objc func startButtonTapped(){
    let popupVC = PopupViewController(title: "💪🏾",
                                      desc: "오늘 운동을 기록할까요?")
    popupVC.modalPresentationStyle = .overFullScreen
    popupVC.popupView.rightButtonAction = { [weak self] in
      guard let self = self else { return }
      self.dismiss(animated: true) {
        let writeHistoryVC = WriteHistoryViewController()
        writeHistoryVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(writeHistoryVC, animated: true)
      }
    }
    self.present(popupVC, animated: false)
  }
  
  func settingHomeVCDatas(){
    homeViewModel.getHomeVCData { datas in
      DispatchQueue.main.async {
        self.timeCountLabel.text = "운동 횟수\n \(datas.0)회"
        self.timeSummaryLabel.text = "주간 평점\n \(datas.1)점"
        self.withFriendsLabel.text = "함께한 친구\n \(datas.2)명"
        
        UIHelper.shared.changeColor(label: self.timeCountLabel, wantToChange: "\(datas.0)회", color: .lightGray)
        UIHelper.shared.changeColor(label: self.timeSummaryLabel, wantToChange: "\(datas.1)점", color: .lightGray)
        UIHelper.shared.changeColor(label: self.withFriendsLabel, wantToChange: "\(datas.2)명", color: .lightGray)
        print(self.homeViewModel.weeklyCompletion)
      
        for (index, isCompleted) in self.homeViewModel.weeklyCompletion.enumerated() {
          if let label = self.weekLabels[safe: index] {
            label.backgroundColor = isCompleted ? .mainBlue : .unableLabelGray
          }
        }
      }
    }
  }
}

// MARK: - collectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    // 추후에 홈에서 데이터 받아오고 해당 데이터를 뿌려줘야함 지금은 임시데이터임
      participateButtonTapped(postedData: CreatePostModel(time: "1", workoutTypes: ["1","2"], gender: "3", info: "3", userNickname: "3", postedDate: "3", userUid: "#"))
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostedCell.id,
                                                  for: indexPath) as! PostedCell

    return cell
  }
}
// 셀의 각각의 크기
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 240, height: collectionView.frame.height)
  }
}

extension HomeViewController: ParticipateButtonDelegate {
  func participateButtonTapped(postedData: CreatePostModel) {
    moveToPostedVC(postedData)
  }
}
extension Array {
    // 배열의 안전한 접근을 위한 subscript 확장
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
