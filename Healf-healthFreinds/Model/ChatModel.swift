//
//  ChatModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/8/24.
//

import ObjectMapper

//. ObjectMapper 라이브러리를 사용하면 복잡한 JSON 데이터를 다룰 때 코드의 가독성과 유지보수성을 높일 수 있다~
class ChatModel: Mappable {
  public var users: Dictionary<String, Bool> = [:] // 채팅방에 참여한 사람들
  public var comments: Dictionary<String, Comment> = [:] // 채팅방의 대화내용
  required init?(map: Map){}
  /*
   <- 연산자는 매핑을 수행하는데 사용, UserData키에 해당하는 JSON 데이터를 users 속성에,
   Comments키에 해당하는 JSON 데이터를 comments 속성에 매핑
   */
  func mapping(map: Map) {
    users <- map["UserData"]
    comments <- map["Comments"]
  }
  
  public class Comment: Mappable {
    public var uid: String?
    public var message: String?
// ObjectMapper가 객체를 생성하고 매핑하는 데 필요한 메서드를 제공하므로 명시적으로 초기화 메서드를 구현할 필요가 없다.
    public required init(map: Map){}
    public func mapping(map: Map){
      uid <- map["uid"]
      message <- map["message"]
    }
  }
}
