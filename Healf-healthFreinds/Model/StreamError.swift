//
//  StreamError.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/6/24.
//

import Foundation

enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}
