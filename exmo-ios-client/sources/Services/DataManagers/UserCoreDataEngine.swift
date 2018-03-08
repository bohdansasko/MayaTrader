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
    static var wallet = WalletCoreDataEngine.sharedInstance

    private var moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    
    init() {
        moc = CoreDataManager.sharedInstance.persistentContainer.viewContext
    }
    
    func isUserExists(uid: Int) -> Bool {
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
    
    func loginUser(uid: Int) -> Bool {
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

        DataService.appSettings.set(userModel.getUID(), forKey: AppSettingsKeys.LastLoginedUID.rawValue)

        let userEntity = User(entity: userEntityDescription, insertInto: moc)
        
        userEntity.setValue(userModel.getUID(), forKey: UserEntity.uid.rawValue)
        //userEntity.setValue(userModel.userInfo?.getBalancesAsStr(), forKey: UserEntity.fieldBalance)
        userEntity.setValue(userModel.qrModel?.key, forKey: UserEntity.key.rawValue)
        userEntity.setValue(userModel.qrModel?.secret, forKey: UserEntity.secret.rawValue)

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

    func deleteLastLoggedUser() {
        let uid = DataService.appSettings.integer(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        deleteUser(uid: uid)
        DataService.appSettings.removeObject(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
    }
    
    func deleteUser(uid: Int) {
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: moc) else {
            return
        }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K==%d", "uid", uid)
        fetchRequest.entity = userEntityDescription

        let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: fetchRequest)
        do {
            try moc.execute(deleteRequest)
            try moc.save()
        } catch let error as NSError {
            NSLog("Unresolved error: \(error), \(error.userInfo)")
        }
    }

}
