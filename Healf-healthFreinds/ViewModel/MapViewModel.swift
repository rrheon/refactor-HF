//
//  MapViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/26/24.
//

import Foundation
import CoreLocation

import FirebaseDatabase

class MapViewModel: CommonViewModel {
  let mypageModelView = MypageViewModel.shared
  static let shared = MapViewModel()
  
  func changeToClLocation(latitude: Double?, longitude: Double?) -> CLLocation? {
    guard let latitude = latitude, let longitude = longitude else { return nil }
    return CLLocation(latitude: latitude, longitude: longitude)
  }
  
  /// 주어진 위도와 경도를 주소로 변환
  /// - Parameters:
  ///   - latitude: 변환할 위도
  ///   - longitude: 변환할 경도
  ///   - completion: 변환된 주소 문자열을 반환하는 클로저
  func changeToAddress(latitude: Double?,
                       longitude: Double?,
                       completion: @escaping (String) -> Void) {
    
    // 위도 및 경도를 소수점 첫째 자리까지 반올림
    let digit: Double = pow(10, 1)
    let roundedLatitude = round((latitude ?? 0.0) * digit) / digit
    let roundedLongtitude = round((longitude ?? 0.0) * digit) / digit
    
    // 반올림된 좌표를 CLLocation 객체로 변환
    let location = changeToClLocation(latitude: roundedLatitude, longitude: roundedLongtitude)
    
    // 주소 변환을 위한 변수 선언
    var address: String = ""
    
    // 유효한 위치가 있는 경우, reverseGeocodeLocation 수행
    if let location = location {
      CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
        if error == nil {
          // 변환된 주소 정보에서 마지막 placemark 가져오기
          guard let placemarks = placemarks,
                let placemark = placemarks.last else { return }
          
          // 주소를 문자열로 변환하여 반환
          address = (placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.first ?? ""
          completion(address)
        } else {
          print("주소로 변환하지 못했습니다.")
        }
      })
    }
  }

  
  /// 사용자의 위치 정보 업데이트
  /// - Parameter userPosition: 업데이트할 사용자의 위치 (위도, 경도)
  func updateMyLocation(_ userPosition: (Double, Double)) {
    // 현재 사용자 정보를 가져옴
    mypageModelView.getMyInfomation { result in
      // 닉네임이 없는 경우 함수 종료
      guard let userNickname = result.nickname else { return }
      
      // 기존 위치 정보 삭제
      self.ref.child("UserLocation").child(result.location ?? "").child(userNickname).removeValue()
      
      // 새로운 위치 정보를 주소로 변환 후 업데이트
      self.changeToAddress(latitude: userPosition.0, longitude: userPosition.1) { userAddress in
        // 변환된 주소를 기반으로 Firebase - UserLocation에 사용자 위치 정보 저장
        self.ref
          .child("UserLocation")
          .child(userAddress)
          .child(userNickname)
          .setValue(self.uid) { (error, ref) in
            if let error = error {
              print("Error adding new key:", error.localizedDescription)
            } else {
              print("New key added successfully!")
            }
          }
        
        // 사용자의 위치 정보를 UserDataInfo 노드에도 업데이트
        self.ref.child("UserDataInfo").child(self.uid ?? "").child("location").setValue(userAddress)
      }
    }
  }

  
  // userdata에서 유저 정보를 다 가져와야함
  func getOtherPersonLocation(completion: @escaping (([UserModel]) -> Void)) {
    var userDatas: [UserModel] = []
    self.ref.child("UserDataInfo").child(self.uid ?? "").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any],
            let location = value["location"] as? String else {
        print("Failed to load user info")
        completion([])
        return
      }
      
      self.ref.child("UserLocation").child(location).observeSingleEvent(of: .value) { snapshot in
        guard let data = snapshot.value as? [String: Any] else {
          print("Failed to convert snapshot to dictionary")
          completion([])
          return
        }
        
        self.mypageModelView.getMyInfomation { result in
          guard let userNickname = result.nickname else { return }
          //uid를 다 받고 순서대로 데이터에 접근해서 유저데이터를 구조체로 변환하고 배열에 하나씩 저장 -> 그 후에 뿌려줌
          for (nickname, uid) in data {
            if userNickname != nickname {
              self.getUserInfomation(uid as? String ?? "") { userData in
                userDatas.append(userData)
                completion(userDatas)
              }
            }
          }
        }
      }
    }
  }
  
  func getUserInfomation(_ uid: String,
                         completion: @escaping(UserModel) -> Void){
    ref.child("UserDataInfo").child(uid).observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else { return }
      guard let userData = self.convertUserModel(data: value) else { return}
      completion(userData)
    }
  }
  
  
}


