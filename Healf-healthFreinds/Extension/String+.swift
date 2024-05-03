//
//  String+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/19/24.
//

import UIKit

import CryptoKit

extension String {
  func getEstimatedFrame(with font: UIFont) -> CGRect {
    let size = CGSize(width: UIScreen.main.bounds.width * 2/3, height: 1000)
    let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    let estimatedFrame = NSString(string: self).boundingRect(with: size,
                                                             options: options,
                                                             attributes: attributes,
                                                             context: nil)
    return estimatedFrame
  }
  
  func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
      fatalError(
        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
      )
    }
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    let nonce = randomBytes.map { byte in
      // Pick a random character from the set, wrapping around if needed.
      charset[Int(byte) % charset.count]
    }
    return String(nonce)
  }
  
  func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
}
