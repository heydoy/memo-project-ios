//
//  Results+Extension.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/10/20.
//

import Foundation
import RealmSwift

extension Results {
  func toArray() -> [Element] {
    return compactMap {
        $0
    }
  }
}
