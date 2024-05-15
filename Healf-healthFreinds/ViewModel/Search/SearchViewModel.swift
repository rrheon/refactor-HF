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

