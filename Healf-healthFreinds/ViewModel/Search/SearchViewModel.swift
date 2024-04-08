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
  
  func loadAllPostsFromDatabase(completion: @escaping (([CreatePostModel]) -> Void)){
    var userPostsArray: [CreatePostModel] = []
    
    createViewModel.loadAllPostsFromDatabase { result in
      for (_, userData) in result {
        guard let userDataDict = userData as? [String: Any],
              let postsDict = userDataDict["posts"] as? [String: [String: Any]] else {
          continue
        }
        
        for (_, postInfo) in postsDict {
          guard let exerciseType = postInfo["exerciseType"] as? [String],
                let gender = postInfo["gender"] as? String,
                let info = postInfo["info"] as? String,
                let time = postInfo["time"] as? String,
                let userNickname = postInfo["userNickname"] as? String,
                let postedDate = postInfo["postedDate"] as? String,
                let userUid = postInfo["userUid"] as? String else {
            continue
          }
          
          let post = CreatePostModel(time: time, workoutTypes: exerciseType,
                                     gender: gender, info: info, userNickname: userNickname,
                                     postedDate: postedDate, userUid: userUid)
          userPostsArray.append(post)
        }
      }
      completion(userPostsArray)
    }
  }
}

