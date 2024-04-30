//
//  Int+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/30/24.
//

import Foundation

extension Int {
  var todayTime: String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
    let date = Date(timeIntervalSince1970: Double(self)/1000)
    return dateFormatter.string(from: date)
  }
}
