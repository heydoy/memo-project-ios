//
//  MemoRepository.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/03.
//

import Foundation
import RealmSwift

protocol MemoRepositoryType {
    func fetch() -> Results<Memo> //항상 최신순으로 가져오기
    func fetchIsPinned(_ bool: Bool) -> Results<Memo>
    func fetchFilter(_ query: String) -> Results<Memo>
    func createMemo(_ item: Memo)
    func updateMemo(_ item: Memo)
    func deleteMemo(_ item: Memo)
}

class MemoRepository: MemoRepositoryType {
    let localRealm = try! Realm()
    
    func fetch() -> Results<Memo> {
        return localRealm.objects(Memo.self).sorted(byKeyPath: "dateCreated", ascending: false) // 항상 최신순으로 가져온다
    }
    
    func fetchIsPinned(_ bool: Bool) -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isPinned == \(bool)")
    }
    
    func fetchFilter(_ query: String) -> Results<Memo> {
        let tasks = localRealm.objects(Memo.self)
        let results = tasks.where {
            $0.title.contains(query) || $0.content.contains(query)
        }
        
        return results
    }
    
    func createMemo(_ item: Memo) {
        do {
            try localRealm.write  {
                localRealm.add(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateMemo(_ item: Memo) {
        do {
            try self.localRealm.write {
                localRealm.add(item, update: .modified)
                
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteMemo(_ item: Memo) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }

}
