//
//  MypageViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit

final class MypageViewController: NaviHelper {
  private lazy var mypageTitleLabel = UIHelper.shared.createSingleLineLabel("마이페이지")
  
  private lazy var userNickNameLabel = UIHelper.shared.createSingleLineLabel("Gildong.Hong")
  private lazy var userProfileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  
  private lazy var workoutCountLabel = UIHelper.shared.createMultipleLineLabel("누적 운동횟수\n6번")
  private lazy var userProfileDeleteButton = UIHelper.shared.createHealfButton(" 프로필 삭제 ", .mainBlue, .white)
  private lazy var userProfileChangeButton = UIHelper.shared.createHealfButton(" 프로필 변경 ", .mainBlue, .white)
  
  private lazy var underUserInfoView = UIView()
  private lazy var userWorkoutPostButton = UIHelper.shared.createButtonWithImage("","MypostImg")
  private lazy var userWorkoutCalenderButton = UIHelper.shared.createButtonWithImage("","CalenderImg")
  
  private lazy var userWorkoutCollectionView = UIHelper.shared.createCollectionView(scrollDirection: .vertical,
                                                                                    spacing: 20)
  private let scrollView = UIScrollView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    
    setupLayout()
    makeUI()
    
    registerCell()
  }
  
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      mypageTitleLabel,
      userNickNameLabel,
      userProfileImageView,
      workoutCountLabel,
      userProfileDeleteButton,
      userProfileChangeButton,
      underUserInfoView,
      userWorkoutPostButton,
      userWorkoutCalenderButton,
      scrollView
    ].forEach {
      view.addSubview($0)
    }
    
    scrollView.addSubview(userWorkoutCollectionView)

  }
  
  // MARK: - makeUI
  func makeUI(){
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    mypageTitleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(20)
    }
    
    userNickNameLabel.snp.makeConstraints {
      $0.top.equalTo(mypageTitleLabel.snp.bottom).offset(20)
      $0.leading.equalTo(mypageTitleLabel)
    }
    
    userProfileImageView.snp.makeConstraints {
      $0.top.equalTo(userNickNameLabel.snp.bottom).offset(10)
      $0.leading.equalTo(mypageTitleLabel)
    }
    
    workoutCountLabel.snp.makeConstraints {
      $0.top.equalTo(userProfileImageView)
      $0.leading.equalTo(userProfileImageView.snp.trailing).offset(50)
    }
    
    userProfileDeleteButton.snp.makeConstraints {
      $0.top.equalTo(workoutCountLabel.snp.bottom).offset(10)
      $0.leading.equalTo(workoutCountLabel)
    }
    
    userProfileChangeButton.snp.makeConstraints {
      $0.top.equalTo(userProfileDeleteButton)
      $0.leading.equalTo(userProfileDeleteButton.snp.trailing).offset(10)
    }
    
    underUserInfoView.backgroundColor = .gray
    underUserInfoView.snp.makeConstraints {
      $0.top.equalTo(userProfileChangeButton.snp.bottom).offset(10)
      $0.height.equalTo(5)
      $0.leading.trailing.equalToSuperview()
    }
    
    userWorkoutPostButton.snp.makeConstraints {
      $0.top.equalTo(underUserInfoView.snp.bottom).offset(10)
      $0.leading.equalTo(workoutCountLabel).offset(20)
    }
    
    userWorkoutCalenderButton.snp.makeConstraints {
      $0.top.equalTo(userWorkoutPostButton)
      $0.leading.equalTo(userWorkoutPostButton.snp.trailing).offset(50)
    }
    
    userWorkoutCollectionView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(scrollView.snp.height)
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(userWorkoutPostButton.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalTo(view)
    }
  }
  
  func registerCell(){
    userWorkoutCollectionView.delegate = self
    userWorkoutCollectionView.dataSource = self
    
    userWorkoutCollectionView.register(SearchResultCell.self,
                                  forCellWithReuseIdentifier: SearchResultCell.id)
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
    return CGSize(width: 350, height: 247)
  }
}
