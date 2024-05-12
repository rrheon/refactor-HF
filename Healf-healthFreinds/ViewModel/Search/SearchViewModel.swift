//
//  SearchViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/12/24.
//

import Foundation

protocol postedDataConfigurable {
  func configure(with data: CreatePostModel, checkMyPost: Bool)
}

final class SearchViewModel: CommonViewModel {
  let createViewModel = CreatePostViewModel.shared
  static let shared = SearchViewModel()
  
  func parsePostInfo(_ postInfo: [String: Any]) -> CreatePostModel? {
      guard let exerciseType = postInfo["exerciseType"] as? [String],
            let gender = postInfo["gender"] as? String,
            let info = postInfo["info"] as? String,
            let time = postInfo["time"] as? String,
            let userNickname = postInfo["userNickname"] as? String,
            let postedDate = postInfo["postedDate"] as? String,
            let userUid = postInfo["userUid"] as? String,
            let location = postInfo["location"] as? String else {
          return nil
      }
      
      return CreatePostModel(time: time, workoutTypes: exerciseType,
                             gender: gender, info: info, userNickname: userNickname,
                             postedDate: postedDate, userUid: userUid, location: location)
  }

  func loadFirstFivePostsFromDatabase(completion: @escaping (([CreatePostModel]) -> Void)){
    var userPostsArray: [CreatePostModel] = []
    
    createViewModel.loadAllPostsFromDatabase { result in
      var count = 0
      for (_, userData) in result {
        guard let userDataDict = userData as? [String: Any],
              let postsDict = userDataDict["posts"] as? [String: [String: Any]] else {
          continue
        }
        
        for (_, postInfo) in postsDict {
          guard count < 5,
                let post = self.parsePostInfo(postInfo) else {
            break
          }
          
          userPostsArray.append(post)
          count += 1
        }
        if count >= 5 { break }
      }
      completion(userPostsArray)
      print(userPostsArray)
    }
  }
  
  func loadAllPostsFromDatabase(completion: @escaping (([CreatePostModel]) -> Void)){
    var userPostsArray: [CreatePostModel] = []
    
    createViewModel.loadAllPostsFromDatabase { result in
      for (_, userData) in result {
        guard let userDataDict = userData as? [String: Any],
              let postsDict = userDataDict["posts"] as? [String: [String: Any]] else {
          continue
        }
        
        for (_, postInfo) in postsDict {
          guard let post = self.parsePostInfo(postInfo) else {
            continue
          }
          userPostsArray.append(post)
        }
      }
      completion(userPostsArray)
    }
  }
}

