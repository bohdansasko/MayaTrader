//
//  RealmDatabaseManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import RealmSwift

class RealmDatabaseManager: OperationsDatabaseProtocol {
    func object<T>(type: T.Type, key: String) -> T? where T : Object {
        return objects(type: type)?.first
    }
    
    func objects<T>(type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? where T : Object {
        if !isRealmAccessible() { return nil }
        
        let realm = try! Realm()
        realm.refresh()
        
        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }
    
    func add<T>(data: [T], update: Bool = true) where T : Object {
        if !isRealmAccessible() { return }
        
        let realm = try! Realm()
        realm.refresh()
        if realm.isInWriteTransaction {
            realm.add(data, update: update)
        } else {
            try? realm.write {
                realm.add(data, update: update)
            }
        }
    }
    
    func add<T>(data: T, update: Bool = true) where T : Object {
        add(data: [data], update: update)
    }
    
    func delete<T>(data: [T]) where T : Object {
        if !isRealmAccessible() { return }
        
        let realm = try! Realm()
        realm.refresh()
        try? realm.write {
            realm.delete(data)
        }
    }
    
    func delete<T>(data: T) where T : Object {
        delete(data: [data])
    }
    
    func clearAllData() {
        if !isRealmAccessible() { return }
        
        let realm = try! Realm()
        realm.refresh()
        try? realm.write {
            realm.deleteAll()
        }
    }
    
    func performTransaction(closure: @escaping () -> Void) {
        if !isRealmAccessible() { return }
        
        let realm = try! Realm()
        realm.refresh()
        
        try? realm.write {
            closure()
        }
    }
}

extension RealmDatabaseManager {
    func isRealmAccessible() -> Bool {
        do {
            _ = try Realm()
            return true
        } catch {
            return false
        }
    }
}
