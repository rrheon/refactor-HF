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
  
  func changeToAddress(latitude: Double?, longitude: Double?,
                       completion: @escaping (String) -> Void) {
    
    let digit: Double = pow(10, 1)
    let roundedLatitude = round((latitude ?? 0.0) * digit) / digit
    let roundedLongtitude = round((longitude ?? 0.0) * digit) / digit
    
    let location = changeToClLocation(latitude: roundedLatitude , longitude: roundedLongtitude)
    var address: String = ""
    if let location = location {
      CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
        if error == nil {
          guard let placemarks = placemarks,
                let placemark = placemarks.last else { return }
          
          address = (placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.first ?? ""
          completion(address)
        } else { print("주소로 변환하지 못했습니다.") }
      })
    }
  }
  
  // 기존의 데이터를 삭제하고 새로운 데이터 저장하기
  func updateMyLocation(_ userPosition: (Double, Double)){
    mypageModelView.getMyInfomation { result in
      guard let userNickname = result.nickname else { return }
      
      self.ref.child("UserLocation").child(result.location ?? "").child(userNickname).removeValue()
      
      self.changeToAddress(latitude: userPosition.0, longitude: userPosition.1) { userAddress in
        self.ref
          .child("UserLocation")
          .child(userAddress)
          .child(userNickname).setValue(self.uid) { (error, ref) in
            if let error = error {
              print("Error adding new key:", error.localizedDescription)
            } else {
              print("New key added successfully!")
            }
          }
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
        return
      }
      
      self.ref.child("UserLocation").child(location).observeSingleEvent(of: .value) { snapshot in
        guard let data = snapshot.value as? [String: Any] else {
          print("Failed to convert snapshot to dictionary")
          return
        }
        
        self.mypageModelView.getMyInfomation { result in
          guard let userNickname = result.nickname else { return }
          //uid를 다 받고 순서대로 데이터에 접근해서 유저데이터를 구조체로 변환하고 배열에 하나씩 저장 -> 그 후에 뿌려줌
          for (nickname, uid) in data {
            print("Nickname:", nickname)
            print("UID:", uid)
            if userNickname != nickname {
              self.getUserInfomation(uid as? String ?? "") { userData in
                userDatas.append(userData)
                completion(userDatas)
                // 여기에서 UI 업데이트를 수행해야 합니다.
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
