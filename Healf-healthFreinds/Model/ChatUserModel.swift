//
//  UserModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import Foundation

// 나중에 프로필사진도 넣어야함
class ChatUserModel: NSObject {
  @objc var nickname: String?
  @objc var uid: String?
  @objc var profileImage: String?
}

struct UserModel: Codable {
  var nickname: String?
  var uid: String?
  var profileImageURL: String?
  var togetherCount: Int?
  var workoutCount: Int?
  var postCount: Int?
  var location: String?
  var introduce: String?
}
