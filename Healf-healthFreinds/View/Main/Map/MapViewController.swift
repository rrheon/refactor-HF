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
import FloatingPanel

final class MapViewController: NaviHelper {
  var fpc: FloatingPanelController!

  private lazy var findUserButton = UIHelper.shared.createSelectButton("이 위치에서 찾기")

  private lazy var naverMapView: NMFNaverMapView = {
    let mapView = NMFNaverMapView()
    mapView.showZoomControls = true
    mapView.showCompass = false
    mapView.showLocationButton = true
    mapView.mapView.positionMode = NMFMyPositionMode.normal
    return mapView
  }()
  
  var locationManager = CLLocationManager()
  let mapViewModel = MapViewModel()
  var userPosition: (Double, Double)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
    
    locationManagerSetting()
    floatingVCSetting()
    
    naverMapView.mapView.addCameraDelegate(delegate: self)
  }
  
  override func navigationItemSetting() {
    redesignNavigation("SearchTextImg")
  }

  // MARK: - setupLayout
  func setupLayout(){
    [
      findUserButton,
      naverMapView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    findUserButton.addAction(UIAction { _ in
      self.findUserButtonTapped()
    }, for: .touchUpInside)
    findUserButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      $0.width.equalTo(150)
      $0.centerX.equalToSuperview()
    }
    
    naverMapView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    view.bringSubviewToFront(findUserButton)
  }
  
  func locationManagerSetting(){
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
  }
  
  func floatingVCSetting(){
    fpc = FloatingPanelController()
    fpc.delegate = self
    
    let contentVC = MapPersonListViewController()
    
    fpc.set(contentViewController: contentVC)
    fpc.addPanel(toParent: self, at: Int(view.bounds.height) * 1/3 , animated: true)
  }
  
  func findUserButtonTapped(){
    guard let userPosition = userPosition else { return }
    mapViewModel.updateMyLocation(userPosition)
    mapViewModel.getOtherPersonLocation(userPosition)
  }
}

extension MapViewController: CLLocationManagerDelegate, NMFMapViewCameraDelegate {
  func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
    print("카메라가 변경됨 : reason : \(reason)")
    let cameraPosition = mapView.cameraPosition

    print(cameraPosition.target.lat, cameraPosition.target.lng)
    userPosition = (cameraPosition.target.lat, cameraPosition.target.lng)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      DispatchQueue.main.async {
        if CLLocationManager.locationServicesEnabled() {
          print("위치 서비스 on")
          self.locationManager.startUpdatingLocation()
          print(self.locationManager.location?.coordinate)
          
          let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(
            lat: self.locationManager.location?.coordinate.latitude ?? 0,
            lng: self.locationManager.location?.coordinate.longitude ?? 0))
          cameraUpdate.animation = .easeIn
          self.naverMapView.mapView.moveCamera(cameraUpdate)
        } else {
          print("위치 서비스 off")
        }
      }
    case .denied, .restricted:
      // 위치 권한이 거부되거나 제한된 경우, 사용자에게 메시지를 표시하거나 적절한 조치를 취합니다.
      print("위치 권한이 거부되었거나 제한됨")
    case .notDetermined:
      // 위치 권한을 요청하지 않은 경우, 요청합니다.
      locationManager.requestWhenInUseAuthorization()
    @unknown default:
      fatalError("Unhandled case")
    }
  }
}

extension MapViewController: FloatingPanelControllerDelegate {
  func floatingPanel(_ fpc: FloatingPanelController,
                     layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
    return FloatingPanelBottomLayout()
  }
}
