//
//  MapPersonListViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/26/24.
//

import UIKit

import SnapKit

class MapPersonListViewController: NaviHelper {
  private lazy var titleLabel = UIHelper.shared.createSingleLineLabel("👥 함께할 친구 : \(userDatas.count)명",
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
  
  let mapViewModel = MapViewModel.shared
  var userDatas: [UserModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapViewModel.getOtherPersonLocation { userDatasFromServer in
      self.userDatas = userDatasFromServer

      self.setupLayout()
      self.makeUI()
    }
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
