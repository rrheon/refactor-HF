//
//  CraeteViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import UIKit

import SnapKit

final class CreateViewController: NaviHelper {
  private lazy var setTimeLabel = UIHelper.shared.createSingleLineLabel("시간대 ⏰")
  private lazy var setTimeTextfield = UIHelper.shared.createGeneralTextField("메세지를 입력해주세요.")

  private lazy var selectWorkoutTitle = UIHelper.shared.createSingleLineLabel("운동 종류 🏋🏻")
  private lazy var cardioButton = UIHelper.shared.createButtonWithImage("유산소","EmptyCheckboxImg")
  private lazy var chestButton = UIHelper.shared.createButtonWithImage("가슴","EmptyCheckboxImg")
  private lazy var backButton = UIHelper.shared.createButtonWithImage("등","EmptyCheckboxImg")
  private lazy var lowerBodyButton = UIHelper.shared.createButtonWithImage("하체","EmptyCheckboxImg")
  private lazy var shoulderButton = UIHelper.shared.createButtonWithImage("어깨","EmptyCheckboxImg")
  private lazy var choiceWorkoutStackView = UIHelper.shared.createStackView(axis: .vertical,
                                                                            spacing: 10)
  
  private lazy var selectGenderTitle = UIHelper.shared.createSingleLineLabel("성별 🚻")
  private lazy var selectMaleButton = UIHelper.shared.createSelectButton("남자만")
  private lazy var selectFemaleButton = UIHelper.shared.createSelectButton("여자만")
  private lazy var selectAllButton = UIHelper.shared.createSelectButton("무관")
  private lazy var selectGenderButtonStackView = UIHelper.shared.createStackView(axis: .horizontal,
                                                                                 spacing: 10)
  
  private lazy var writeDetailInfoLabel = UIHelper.shared.createSingleLineLabel("내용")
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItemSetting()
    
    view.backgroundColor = .white
    
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    settingNavigationTitle(title: "매칭 등록하기 📬")
  }
}


