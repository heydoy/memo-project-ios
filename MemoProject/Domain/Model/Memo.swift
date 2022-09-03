//
//  Memo.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/03.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var content: String? // 내용이 없을 수도 있음
    @Persisted var dateCreated = Date() // 최초작성시각
    @Persisted var dateModified = Date() // 수정한 시각
    @Persisted var isPinned: Bool // 고정메모 여부
    
    convenience init(title: String, content: String?, dateCreated: Date, dateModified: Date ) {
        self.init()
        
        self.title = title
        self.content = content
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.isPinned = false
    }
}