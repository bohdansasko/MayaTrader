//
//  RealmDatabaseManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import RealmSwift

final class RealmDatabaseManager: OperationsDatabaseProtocol {
    static let shared = RealmDatabaseManager()

    private init() {
        let config = Realm.Configuration(
          schemaVersion: 1,
          deleteRealmIfMigrationNeeded: true
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    func object<T>(type: T.Type) -> T? where T : Object {
        return objects(type: type)?.first
    }

    func object<T>(type: T.Type, key: String) -> T? where T : Object {
        return objects(type: type)?.first
    }
    
    func objects<T>(type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? where T : Object {
        if !isRealmAccessible() { return nil }
        
        guard let realm = try? Realm() else {
            return nil
        }
        realm.refresh()
        
        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }
    
    func add<T>(data: [T], update: Bool = true) where T : Object {
        if !isRealmAccessible() { return }
        
        guard let realm = try? Realm() else {
            return
        }
        realm.refresh()
        
        if realm.isInWriteTransaction {
            realm.add(data, update: .all)
        } else {
            try? realm.write {
                realm.add(data, update: .all)
            }
        }
    }
    
    func add<T>(data: T, update: Bool = true) where T : Object {
        add(data: [data], update: update)
    }
    
    func delete<T>(data: [T]) where T : Object {
        if !isRealmAccessible() { return }
        
        guard let realm = try? Realm() else {
            return
        }
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
        
        guard let realm = try? Realm() else {
            return
        }
        realm.refresh()
        try? realm.write {
            realm.deleteAll()
        }
    }
    
    func performTransaction(closure: @escaping () -> Void) {
        if !isRealmAccessible() { return }
        
        guard let realm = try? Realm() else {
            return
        }
        realm.refresh()
        
        try? realm.write {
            closure()
        }
    }
    
    func isInWriteTransaction() -> Bool {
        if !isRealmAccessible() { return false }
        
        guard let realm = try? Realm() else {
            return false
        }
        realm.refresh()
        
        return realm.isInWriteTransaction
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
