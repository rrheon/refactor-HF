//
//  UserDefaultManager.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/6/24.
//

import Foundation

struct UserDefaultManager {
  static var displayName: String {
    get {
      UserDefaults.standard.string(forKey: "DisplayName") ?? ""
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "DisplayName")
    }
  }
}
