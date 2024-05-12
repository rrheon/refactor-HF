//
//  NotificationModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 5/10/24.
//

import ObjectMapper

class NotificationModel: Mappable {
  public var to: String?
  public var notification: Notification = Notification()
  
  init(){
    
  }
  required init?(map: Map) {
    
  }
  func mapping(map: Map) {
    to <- map["to"]
    notification <- map["notification"]
  }
  
  class Notification: Mappable {
    public var title: String?
    public var text: String?
    init(title: String? = nil, text: String? = nil) {
      self.title = title
      self.text = text
    }
    required init(map: Map) {
      
    }
    
    func mapping(map: Map) {
      title <- map["title"]
      text <- map["text"]
    }
  }
}
