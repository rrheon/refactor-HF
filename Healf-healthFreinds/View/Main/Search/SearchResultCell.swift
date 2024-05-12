//
//  SearchResultCell.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/2/24.
//

import UIKit

import SnapKit

protocol ParticipateButtonDelegate {
  func participateButtonTapped(postedData: CreatePostModel)
}

final class SearchResultCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  var delegate: ParticipateButtonDelegate?
  var checkMyPost: Bool = false
  
  private lazy var profileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var nickNameLabel = UIHelper.shared.createSingleLineLabel("닉네임")
  private lazy var postedDate = UIHelper.shared.createSingleLineLabel("2024.03.02")
  
  private lazy var titleLabel = UIHelper.shared.createBasePaddingLabel(
    "운동해요~~",
    backgroundColor: .init(hexCode: "#F8F8F8"),
    textColor: .black)
  private lazy var locationLabel = UIHelper.shared.createSingleLineLabel("📍 송도 1동",
                                                                         .mainBlue,
                                                                         .boldSystemFont(ofSize: 15))
  private lazy var participateButton = UIHelper.shared.createHealfButton("참여하기", .mainBlue, .white)
  private lazy var menuButton = UIHelper.shared.createButtonWithImage("     ",
                                                                      "MyPostMenuImg",
                                                                      checkButton: false)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .white
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
      locationLabel,
      titleLabel,
      profileImageView,
      nickNameLabel,
      postedDate,
      participateButton,
      menuButton
    ].forEach {
      addSubview($0)
    }
    
  }
  
  private func configure() {
    profileImageView.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(20)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.centerY.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    postedDate.snp.makeConstraints {
      $0.centerY.equalTo(profileImageView)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(10)
      $0.leading.equalTo(profileImageView)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(40)
      $0.leading.equalTo(profileImageView)
    }
    
    participateButton.snp.makeConstraints {
      $0.centerY.equalTo(locationLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(35)
      $0.width.equalTo(110)
    }
    
    menuButton.snp.makeConstraints {
      $0.centerY.equalTo(locationLabel)
      $0.trailing.equalTo(postedDate.snp.trailing)
    }
  }
}

extension SearchResultCell: postedDataConfigurable {
  func configure(with data: CreatePostModel, checkMyPost: Bool = false) {
    participateButton.isHidden = checkMyPost
    menuButton.isHidden = !checkMyPost
    
    nickNameLabel.text = data.userNickname
    titleLabel.text = data.info
    postedDate.text = data.postedDate
    locationLabel.text = "📍 \(data.location)"
    MypageViewModel.shared.getUserProfileImage(checkMyUid: false,
                                        otherPersonUid: data.userUid) { result in
      MypageViewModel.shared.settingProfileImage(profile: self.profileImageView,
                                               result: result,
                                               radious: 25)
    }
    
    participateButton.addAction(UIAction { _ in
      self.delegate?.participateButtonTapped(postedData: data)
    }, for: .touchUpInside)
    
    menuButton.addAction(UIAction { _ in
      self.delegate?.participateButtonTapped(postedData: data)
    }, for: .touchUpInside)
    
  }
}
