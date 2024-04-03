//
//  Disposable+.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/2/24.
//

import RxSwift

extension Disposable {
  public func disposed(by bag: DisposeBag) {
    bag.insert(self)
  }
}
