//
//  MapViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/26/24.
//

import Foundation
import CoreLocation

class MapViewModel: CommonViewModel {
  
  func changeToClLocation(latitude: Double?, longitude: Double?) -> CLLocation? {
    guard let latitude = latitude, let longitude = longitude else { return nil }
    return CLLocation(latitude: latitude, longitude: longitude)
  }
  
  func changeToAddress(latitude: Double?, longitude: Double?,
                       completion: @escaping (String) -> Void) {
    let location = changeToClLocation(latitude: latitude , longitude: longitude)
    var address: String = ""
    
    if let location = location {
      CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
        if error == nil {
          guard let placemarks = placemarks,
                let placemark = placemarks.last else { return }
          
          address = (placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.first ?? ""
          completion(address)
        } else {
          print("주소로 변환하지 못했습니다.")
        }
      })
    }
    
  }

  func updateMyLocation(_ userPosition: (Double, Double)){
    let sanitizedUID = uid?.replacingOccurrences(of: ".", with: "_")
    
    let locationString = "\(userPosition.0)_\(userPosition.1)"
    
    ref.child("UserLocation").child(locationString).setValue(sanitizedUID) { (error, ref) in
      if let error = error {
        print("Error adding new key:", error.localizedDescription)
      } else {
        print("New key added successfully!")
      }
    }
  }
  

  
  func getOtherPersonLocation(_ userPosition: (Double, Double)) {
      ref.child("UserDataInfo").observeSingleEvent(of: .value) { snapshot in
          guard let value = snapshot.value as? [String: Any] else {
              print("Failed to load user data")
              return
          }
          do {
              // JSONSerialization을 사용하여 데이터를 JSON 데이터로 변환합니다.
              let jsonData = try JSONSerialization.data(withJSONObject: value)
              // JSONDecoder를 사용하여 JSON 데이터를 UsersData 구조체로 디코딩합니다.
              let usersData = try JSONDecoder().decode(UserModel.self, from: jsonData)
              print(usersData)
          } catch {
              print("Error decoding data: \(error.localizedDescription)")
          }
      }
  }

}

