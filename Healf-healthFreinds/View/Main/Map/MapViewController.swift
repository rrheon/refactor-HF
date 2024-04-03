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
    mapView.showCompass = false
    mapView.mapView.positionMode = NMFMyPositionMode.normal
    return mapView
  }()
  
  var locationManager = CLLocationManager()
  let mapViewModel = MapViewModel()
  var userPosition: (Double, Double)?
  var userLocation: CLLocation?

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
    locationManager.startUpdatingLocation()
  }
  
  func floatingVCSetting(){
    fpc = FloatingPanelController()
    fpc.delegate = self
    
    let contentVC = MapPersonListViewController()
    
    fpc.set(contentViewController: contentVC)
    fpc.addPanel(toParent: self, at: Int(view.bounds.height) * 1/3 , animated: true)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.first else { return }
      userLocation = location
      
      // 사용자의 위치를 받아온 후 해당 위치로 이동하거나 처리할 수 있습니다.
      moveToUserLocation()
  }
  
  func moveToUserLocation() {
    guard let userLocation = userLocation else { return }
    
    // 여기에서 사용자의 위치를 이용하여 지도 상에서 해당 위치로 이동하는 작업을 수행합니다.
    let latitude = userLocation.coordinate.latitude
    let longitude = userLocation.coordinate.longitude
    
    userPosition = (latitude, longitude)

    // 예를 들어, NMFNaverMapView를 사용하여 사용자의 위치로 지도 이동
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
    naverMapView.mapView.moveCamera(cameraUpdate)
  }
  
  func findUserButtonTapped(){
    guard let userPosition = userPosition else { return }
    mapViewModel.changeToAddress(latitude: userPosition.0, longitude: userPosition.1) { result in
      print(result)
    }
//    mapViewModel.getOtherPersonLocation(userPosition)
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
