//
//  OperationsDatabaseProtocol.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import RealmSwift

protocol OperationsDatabaseProtocol {
    func object<T: Object>(type: T.Type, key: String) -> T?
    func objects<T: Object>(type: T.Type, predicate: NSPredicate?) -> Results<T>?
    func add<T: Object>(data: [T], update: Bool)
    func add<T: Object>(data: T, update: Bool)
    func delete<T: Object>(data: T)
    func clearAllData()
    func performTransaction(closure: @escaping () -> Void)
    func isInWriteTransaction() -> Bool
}
