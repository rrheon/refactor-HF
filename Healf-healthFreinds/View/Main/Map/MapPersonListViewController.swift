//
//  MapPersonListViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/26/24.
//

import UIKit

import SnapKit

class MapPersonListViewController: NaviHelper {
  private lazy var titleLabel = UIHelper.shared.createSingleLineLabel(
    "👥 함께할 친구 : \(userDatas.count)명",
    .mainBlue,
    .systemFont(ofSize: 14))
  
  private lazy var personListTableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MapPersonCell.self, forCellReuseIdentifier: MapPersonCell.cellId)
    tableView.rowHeight = UITableView.automaticDimension
    
    return tableView
  }()
  
  private lazy var nonPersonListLabel = uihelper.createMultipleLineLabel(
    "해당 위치에 함꼐할 친구가 없어요\n위치를 등록하거나 새로운 장소를 찾아주세요!")
  let mapViewModel = MapViewModel.shared
  var userDatas: [UserModel] = [] {
    didSet{
      titleLabel.text = "👥 함께할 친구 : \(userDatas.count)명"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 0일 경우 처리 필요
    getOtherUserData()
    nonPersonList()
  }
  
  func setupLayout(){
    [
      titleLabel,
      personListTableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    personListTableView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview()
    }
  }
  
  func nonPersonList(){
    if userDatas.count == 0 {
      view.addSubview(nonPersonListLabel)
      nonPersonListLabel.snp.makeConstraints {
        $0.centerX.centerY.equalToSuperview()
      }
    }
  }
  
  func getOtherUserData(){
    mapViewModel.getOtherPersonLocation { userDatasFromServer in
      print("데이터: \(userDatasFromServer)")
      self.userDatas = userDatasFromServer

      self.setupLayout()
      self.makeUI()
      self.personListTableView.reloadData()
    }
  }
  
  func printTest(){
    print("personVC")
  }
}

extension MapPersonListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    return self.usersInChatrooms.count
    return userDatas.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MapPersonCell.cellId,
                                             for: indexPath) as! MapPersonCell
    cell.cellDataSetting(userDatas[indexPath.row])
    return cell
  }
  
}
