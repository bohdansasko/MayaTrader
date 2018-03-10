//
//  WalletCoreDataEngine.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import CoreData

class WalletCoreDataEngine {
    static var sharedInstance = WalletCoreDataEngine()

    private var moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)

    init() {
        moc = CoreDataManager.sharedInstance.persistentContainer.viewContext
    }

    func getWalletInfo() -> WalletModel {
        let wallet = WalletModel()
        return wallet
    }

    func saveWalletData(user: User) -> Bool {
        return true
    }
}
