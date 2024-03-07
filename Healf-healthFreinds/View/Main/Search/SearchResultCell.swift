//
//  SearchResultCell.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit

final class SearchResultCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  private lazy var locationLabel = UIHelper.shared.createBasePaddingLabel("인천 송도")
  private lazy var titleLabel = UIHelper.shared.createSingleLineLabel("운동해요~~")

  private lazy var memberNumberLabel = UIHelper.shared.createSingleLineLabel("인원수")
  private lazy var memberCountImage = UIImageView(image: UIImage(named: "PersonImg"))
  private lazy var memberCountLabel = UIHelper.shared.createSingleLineLabel("3명")
  private lazy var memberStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 5)
  
  private lazy var workoutTitleLabel = UIHelper.shared.createSingleLineLabel("운동종류")
  private lazy var workoutImage = UIImageView(image: UIImage(named: "PersonImg"))
  private lazy var workoutLabel = UIHelper.shared.createSingleLineLabel("가슴")
  private lazy var workoutStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 5)
 
  private lazy var genderTitleLabel = UIHelper.shared.createSingleLineLabel("성별")
  private lazy var genderImage = UIImageView(image: UIImage(named: "GenderMixImg"))
  private lazy var genderLabel = UIHelper.shared.createSingleLineLabel("무관")
  private lazy var genderStackView = UIHelper.shared.createStackView(axis: .vertical, spacing: 5)
  
  private lazy var infoStackView = UIHelper.shared.createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var profileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))

  private lazy var nickNameLabel = UIHelper.shared.createSingleLineLabel("닉네임")
  private lazy var postedDate = UIHelper.shared.createSingleLineLabel("2024.03.02")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setViewShadow(backView: self)
    
    addSubviews()
    configure()
    
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addSubviews() {
    [
      memberNumberLabel,
      memberCountImage,
      memberCountLabel
    ].forEach {
      memberStackView.addArrangedSubview($0)
    }
    
    [
      workoutTitleLabel,
      workoutImage,
      workoutLabel
    ].forEach {
      workoutStackView.addArrangedSubview($0)
    }
    
    [
      genderTitleLabel,
      genderImage,
      genderLabel
    ].forEach {
      genderStackView.addArrangedSubview($0)
    }
    
    [
      memberStackView,
      workoutStackView,
      genderStackView
    ].forEach {
      infoStackView.addArrangedSubview($0)
    }
    
    [
      locationLabel,
      titleLabel,
      infoStackView,
      profileImageView,
      nickNameLabel,
      postedDate,
    ].forEach {
      addSubview($0)
    }

  }
  
  private func configure() {
    locationLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().offset(10)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(locationLabel.snp.bottom).offset(10)
      $0.leading.equalTo(locationLabel)
    }
    
    [
      memberStackView,
     workoutStackView,
     genderStackView
    ].forEach {
      $0.alignment = .center
      $0.backgroundColor = .clear
    }
    

    
    infoStackView.distribution = .fillEqually
    infoStackView.backgroundColor = .searchStackViewColor
    infoStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(infoStackView.snp.bottom).offset(10)
      $0.leading.equalTo(locationLabel)
      $0.height.width.equalTo(34)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
      $0.top.equalTo(profileImageView.snp.top)
    }
    
    postedDate.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
      $0.top.equalTo(nickNameLabel.snp.bottom).offset(5)
    }
  }
  
 
}

