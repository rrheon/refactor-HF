//
//  EditMyProfileViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/4/24.
//

import AVFoundation
import Photos
import UIKit

import SnapKit
import Kingfisher
import Then

// 닉네임 변경추가하기
class EditMyProfileViewController: NaviHelper {
  
  private lazy var profileImageView = UIImageView(image: UIImage(named: "EmptyProfileImg"))
  private lazy var profileChangeButton = UIButton().then {
    $0.setTitle("변경", for: .normal)
    $0.setTitleColor(.mainBlue, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12)
    $0.addAction(UIAction { _ in
      self.changeProfileImageButtonTapped()
    }, for: .touchUpInside)
  }

  private lazy var profileDeleteButton = UIButton().then {
    $0.setTitle("삭제", for: .normal)
    $0.setTitleColor(.unableGray, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12)
    $0.addAction(UIAction { _ in
      self.deleteProfileImageButtonTapped()
    }, for: .touchUpInside)
  }
  
  private lazy var profileEditStaackView = uihelper.createStackView(axis: .horizontal, spacing: 5)
  
  private lazy var introduceLabel = uihelper.createSingleLineLabel("소개",
                                                                   .mainBlue,
                                                                   .boldSystemFont(ofSize: 14))
  
  private lazy var introduceTextFiled = uihelper.createLoginTextField("소개")
  
  private lazy var nicknameLabel = uihelper.createSingleLineLabel("닉네임",
                                                                   .mainBlue,
                                                                   .boldSystemFont(ofSize: 14))
  
  private lazy var editNicknameTextField = uihelper.createLoginTextField("닉네임")
  
  var existingNickname = ""
  let editProfileViewModel = EditMyProfileViewModel()
  weak var delegate: ImageSelectionDelegate?

  init(delegate: ImageSelectionDelegate? = nil,
       profileImage: UIImage,
       introduce: String,
       nickname: String) {
    super.init()

    self.delegate = delegate
    self.profileImageView.image = profileImage
    self.profileImageView.layer.cornerRadius = 35
    self.profileImageView.clipsToBounds = true

    self.introduceTextFiled.text = introduce
    self.editNicknameTextField.text = nickname
    existingNickname = nickname
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
    
    hideKeyboardWhenTappedAround()
  }
  
  // MARK: - setuplayout
  func setupLayout(){
    [
      profileChangeButton,
      profileDeleteButton
    ].forEach {
      profileEditStaackView.addArrangedSubview($0)
    }
    
    [
      profileImageView,
      profileEditStaackView,
      introduceLabel,
      introduceTextFiled,
      nicknameLabel,
      editNicknameTextField
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(150)
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(80)
    }
    
    profileEditStaackView.backgroundColor = .clear
    profileEditStaackView.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(10)
      $0.centerX.equalTo(profileImageView)
    }
    
    introduceLabel.snp.makeConstraints {
      $0.top.equalTo(profileEditStaackView.snp.bottom).offset(30)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    introduceTextFiled.snp.makeConstraints {
      $0.top.equalTo(introduceLabel.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(introduceTextFiled.snp.bottom).offset(20)
      $0.leading.equalTo(introduceTextFiled)
    }
    
    editNicknameTextField.snp.makeConstraints {
      $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(introduceTextFiled)
    }
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    settingNavigationTitle(title: "프로필 편집")
    
    let completeImg = UIImage(named: "CompleteImg")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: #selector(completeButtonTapped))
    completeButton.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    
    self.navigationItem.rightBarButtonItem = completeButton
  }
  
  // MARK: - completeButtonTapped
  @objc func completeButtonTapped(){
    guard let introduce = introduceTextFiled.text,
          let image = profileImageView.image,
          let nickname = editNicknameTextField.text else { return }
    if existingNickname == nickname {
      self.editProfileViewModel.saveMyProfile(introduce: introduce,
                                              nickname: nickname,
                                              profileImage: image)
//      self.changeMyProfile()
      self.navigationController?.popViewController(animated: true)
    } else {
//      SignupViewModel.shared.checkDuplication(checkType: "nickname",
//                                              checkValue: nickname) { [weak self] result in
//        switch result{
//        case true:
//          self?.editProfileViewModel.saveMyProfile(introduce: introduce,
//                                                   nickname: nickname,
//                                                   profileImage: image)
//          self?.changeMyProfile()
//          self?.navigationController?.popViewController(animated: true)
//        case false:
//          self?.editNicknameTextField.resignFirstResponder()
//          self?.showPopupViewWithOnebuttonAndDisappearVC("이미 사용중인 닉네임입니다.")
//          
        }
      }
    

  
  // MARK: - changeProfileButtonTapped
  func changeProfileImageButtonTapped(){
//    let bottomSheetVC = BottomSheet(firstButtonTitle: "앨범에서 선택하기",
//                                    secondButtonTitle: "닫기")
//    bottomSheetVC.delegate = self
//    
//    uihelper.settingBottomeSheet(bottomSheetVC: bottomSheetVC, size: 150)
//    present(bottomSheetVC, animated: true, completion: nil)
  }
  
  // MARK: - deleteProfile
  func deleteProfileImageButtonTapped(){
//    profileImageView.image = UIImage(named: "EmptyProfileImg")
//    uihelper.showToast(message: "✅ 기존 프로필 이미지를 삭제했어요!")
  }
  
  // MARK: - changeMyProfile
  func changeMyProfile() {
//    if let newImage = profileImageView.image,
//       let introduce = introduceTextFiled.text,
//       let nickname = editNicknameTextField.text {
//      delegate?.didSelectImage(image: newImage, nickname: nickname, introduce: introduce)
//      navigationController?.popViewController(animated: true)
//    }
  }
}

// MARK: - bottomSheet Delegate
extension EditMyProfileViewController: BottomSheetDelegate {
  // 앨범에서 선택하기
  func firstButtonTapped(_ postedData: CreatePostModel?) {
    requestPhotoLibraryAccess()
  }
  
  func secondButtonTapped(_ postedData: CreatePostModel?) {
    print("222")
  }
  
  // 프로필 이미지 변경
  func changeProfileImage(type: UIImagePickerController.SourceType){
    self.dismiss(animated: true)
    
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = type
    picker.allowsEditing = true
    self.present(picker, animated: true)
  }
 
  func requestPhotoLibraryAccess() {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      switch status {
      case .authorized:
        DispatchQueue.main.async {
          self?.changeProfileImage(type: .photoLibrary)
        }
      case .denied, .restricted:
        DispatchQueue.main.async {
          self?.showAccessDeniedAlert()
        }
      case .notDetermined:
        self?.requestPhotoLibraryAccess()
      default:
        break
      }
    }
  }
  
  func showAccessDeniedAlert() {
//    let popupVC = PopupViewController(
//      title: "사진을 변경하려면 허용이 필요해요",
//      desc: "",
//      leftButtonTitle: "취소",
//      rightButtonTilte: "설정"
//    )
//    
//    popupVC.popupView.leftButtonAction = {
//      self.dismiss(animated: true, completion: nil)
//    }
//    
//    popupVC.popupView.rightButtonAction = {
//      self.dismiss(animated: true) {
//        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
//        UIApplication.shared.open(settingsURL)
//      }
//    }
//    popupVC.modalPresentationStyle = .overFullScreen
//    self.present(popupVC, animated: false)
  }
}

// 사진 선택
extension EditMyProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
      DispatchQueue.main.async {
        self.profileImageView.image = image
        self.profileImageView.layer.cornerRadius = 35
        self.profileImageView.clipsToBounds = true
      }
      
      KingfisherManager.shared.cache.clearMemoryCache()
      KingfisherManager.shared.cache.clearDiskCache {
        self.dismiss(animated: true)
      }
    }
  }
}
