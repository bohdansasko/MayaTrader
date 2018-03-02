//
//  UserCoreDataEngine.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import CoreData

class UserCoreDataEngine {
    static var sharedInstance = UserCoreDataEngine()
    
    var moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    
    init() {
        moc = CoreDataManager.sharedInstance.persistentContainer.viewContext
    }
    
    func saveUser(userModel: UserModel) {
        // do nothing
    }

    func deleteUser(userModel: UserModel) {
        // do nothing
    }
    
    func getUserInfo() -> UserModel {
        // do nothing
        return UserModel()
    }

}
