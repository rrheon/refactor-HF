//
//  MapViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/26/24.
//

import Foundation

class MapViewModel: CommonViewModel {
  
  func updateMyLocation(_ userPosition: (Double, Double)){
    var convertUserPosition: [Double] = []
    
    convertUserPosition.append(userPosition.0)
    convertUserPosition.append(userPosition.1)
    
    ref.child("UserDataInfo").child(uid ?? "").child("location").setValue("\(convertUserPosition)") { (error, ref) in
      if let error = error {
        print("Error adding new key: \(error.localizedDescription)")
      } else {
        print("New key added successfully!")
      }
    }
  }
  
  func getOtherPersonLocation(_ userPosition: (Double, Double)){
    ref.child("UserDataInfo").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [String: Any] else {
        print("Failed to load user posts")
        return
      }
      print(value)
    }

  }
}

