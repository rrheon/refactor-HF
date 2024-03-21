//
//  Array+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/19/24.
//

import Foundation

extension Array {
  // 배열의 안전한 접근을 위한 subscript 확장
  subscript(safe index: Int) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

