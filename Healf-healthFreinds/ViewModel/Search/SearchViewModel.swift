//
//  SearchViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/12/24.
//

import Foundation

import RxSwift
import RxRelay

protocol postedDataConfigurable {
  func configure(with data: CreatePostModel, checkMyPost: Bool)
}

final class SearchViewModel: CommonViewModel {
  let createViewModel = CreatePostViewModel.shared
  static let shared = SearchViewModel()
  
  lazy var allPostDatas = BehaviorRelay<[CreatePostModel]?>(value: nil)
  
  override init() {
    super.init()
    updateAllPosts(location: nil)
  }
  
  func updateAllPosts(location: String?){
    loadPostsFromDatabase(location: location)
      .subscribe(onNext: { [weak self] newData in
        self?.allPostDatas.accept(newData)
      })
      .disposed(by: disposeBag)
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
  
  func loadPostsFromDatabase(location: String?) -> Observable<[CreatePostModel]?> {
    return Observable.create { emitter in
      var userPostsArray: [CreatePostModel] = []
      
      self.createViewModel.loadAllPostsFromDatabase { result in
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
        
        // 게시글 배열 정렬
        userPostsArray.sort { $0.postedDate > $1.postedDate }
        
        if let location = location {
          let filteredPosts = userPostsArray.filter { $0.location == location }
          emitter.onNext(filteredPosts)
        } else {
          emitter.onNext(userPostsArray)
        }
        emitter.onCompleted()
      }
      
      return Disposables.create()
    }
  }
}

