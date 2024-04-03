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
  func getOtherPersonLocation() {
    self.ref.child("UserDataInfo").child(self.uid ?? "").observe( .value) { snapshot  in
      guard let value = snapshot.value as? [String: Any] else {
        print("Failed to load user info")
        return
      }
      
      let location = value["location"] as? String
      print(location)
      // 이걸로 위치 넣으면 될듯
    }
    

//
//    ref.child("UserLocation").child(userAddress).observeSingleEvent(of: .value) { dataSnap in
//      // 데이터 스냅샷을 순회하여 각 사용자 위치 정보에 접근
//      for child in dataSnap.children {
//        // 데이터 스냅샷의 각 자식 항목에 대한 참조 생성
//        let childSnapshot = child as! DataSnapshot
//        
//        // 자식 항목의 값 가져오기
//        guard let userData = childSnapshot.value as? [String: Any] else {
//          continue
//        }
//        
//        // 필요한 데이터 추출
//        if let address = userData["address"] as? String {
//          // 주소 데이터 사용
//          print(address)
//        }
//        
//        if let uid = userData["uid"] as? String {
//          // 사용자 UID 데이터 사용
//          print(uid)
//        }
//        
//        // 필요한 다른 데이터에 대한 작업 수행
//      }
//    }
  }
  
}
