//
//  URLSet.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/21/24.
//

import Foundation

/// Url 타입
enum UrlType {
  static let personInfo = "personInfo"
  static let seriveInfo = "service"
  static let contact = "contact"
}

/// Plist Loader
class DataLoaderFromPlist {
  private class func loadData(_ from: String) -> [String: String]? {
    if let url = Bundle.main.url(forResource: from, withExtension: "plist") {
      do {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        let urlData = try decoder.decode([String: String].self, from: data)
        return urlData
      } catch {
        print("Error decoding Plist: \(error)")
      }
    }
    return nil
  }
  
  /// URL 주소 가져오기 - 서비스이용약관, 개인정보 처리방침,연락하기
  /// - Returns: 주소
  class func loadURLs() -> [String: String]? {
    return loadData("UrlList")
  }

}
