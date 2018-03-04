//
//  UserCoreDataEngine.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import CoreData

struct UserEntity {
    static let fieldUID = "uid"
    static let fieldKey = "key"
    static let fieldSecret = "secret"
    static let fieldBalances = "balances"
}

class UserCoreDataEngine {
    static var sharedInstance = UserCoreDataEngine()
    
    var moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    
    init() {
        moc = CoreDataManager.sharedInstance.persistentContainer.viewContext
    }
    
    func isUserExists() -> Bool {
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: moc) else {
            return false
        }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.entity = userEntityDescription
        
        do {
            let result = try moc.fetch(fetchRequest)
            if (result.count == 1) {
                print("UserCoreDataEngine: user exists")
                return true
            }
            print("UserCoreDataEngine: user doesn't exists")
            return false
        } catch let error as NSError {
            NSLog("Unresolved error: \(error), \(error.userInfo)")
            return false
        }
    }
    
    func loginUser() -> Bool {
        let uid = 1255830; // need load from user settings
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: moc) else {
            return false
        }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K==%d", "uid", uid)
        fetchRequest.entity = userEntityDescription
        
        do {
            let result = try moc.fetch(fetchRequest)
            if (result.count == 1) {
                return true
            }
            return false
        } catch let error as NSError {
            NSLog("Unresolved error: \(error), \(error.userInfo)")
            return false
        }
    }
    
    func saveUserData(userModel: UserModel) -> Bool {
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: moc) else {
            return false
        }
        
        let userEntity = User(entity: userEntityDescription, insertInto: moc)
        
        userEntity.setValue(userModel.userInfo?.uid, forKey: UserEntity.fieldUID)
        // userEntity.setValue(userModel.userInfo?.getBalancesAsStr(), forKey: UserEntity.fieldBalance)
        userEntity.setValue(userModel.qrModel?.key, forKey: UserEntity.fieldKey)
        userEntity.setValue(userModel.qrModel?.secret, forKey: UserEntity.fieldSecret)

        do {
            try moc.save()
            print("user info saved to local db")
            return true
        } catch {
            let nsError = error as NSError
            NSLog("Unresolved error: \(nsError), \(nsError.userInfo)")
            return false
        }
    }

    func deleteUser(userModel: UserModel) {
        // do nothing
    }
    
    func getUserInfo() -> UserModel {
        // do nothing
        return UserModel()
    }

}
