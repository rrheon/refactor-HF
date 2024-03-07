//
//  MapViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/1/24.
//

import UIKit
import CoreLocation

import SnapKit
import NMapsMap

final class MapViewController: NaviHelper, NMFMapViewCameraDelegate {
  private lazy var naverMapView: NMFNaverMapView = {
    let mapView = NMFNaverMapView()
    mapView.showZoomControls = true
    mapView.showCompass = false
    mapView.showLocationButton = true
    mapView.mapView.positionMode = NMFMyPositionMode.normal
    return mapView
  }()
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.delegate = self
    return manager
  }()
  
  private let searchBar = UISearchBar.createSearchBar(placeholder: "원하는 지역을 입력해주세요.")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()

    self.locationManager.requestWhenInUseAuthorization()
    
  
      locationManager.startUpdatingLocation() //위치 정보 받아오기 시작
    
  }
  
  override func navigationItemSetting() {
    redesignNavigation("SearchTextImg")
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      searchBar,
      naverMapView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    naverMapView.snp.makeConstraints {
      $0.top.equalTo(searchBar)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    view.bringSubviewToFront(searchBar)
  }
  

}

extension MapViewController: CLLocationManagerDelegate {
  func getLocationUsagePermission() {
    self.locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
    //location5
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      print("GPS 권한 설정됨")
      self.locationManager.startUpdatingLocation() // 중요!
    case .restricted, .notDetermined:
      print("GPS 권한 설정되지 않음")
      getLocationUsagePermission()
    case .denied:
      print("GPS 권한 요청 거부됨")
      getLocationUsagePermission()
    default:
      print("GPS: Default")
    }
  }
  
  
}
