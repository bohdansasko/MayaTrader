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

    private var moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    
    init() {
        moc = CoreDataManager.sharedInstance.persistentContainer.viewContext
    }

    func loadUserData(uid: Int) -> UserEntity? {
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: moc) else {
            return nil
        }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K==%d", "uid", uid)
        fetchRequest.entity = userEntityDescription

        var user: UserEntity? = nil
        do {
            let result = try moc.fetch(fetchRequest)
            if result.count > 0 {
                let u = result.first as? UserEntity
                user = u
            }
            return user
        } catch let error as NSError {
            NSLog("Unresolved error: \(error), \(error.userInfo)")
            return nil
        }
    }

    func loadQRData() -> QRLoginModel {
        let qrData = QRLoginModel()
        return qrData
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
    
    func saveUserData(User: User) -> Bool {
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: moc) else {
            return false
        }

        CacheManager.sharedInstance.appSettings.set(User.getUID(), forKey: AppSettingsKeys.LastLoginedUID.rawValue)

        let userEntity = UserEntity(entity: userEntityDescription, insertInto: moc)
//        userEntity.setValue(User.getUID(), forKey: UserEntity.uid.rawValue)
//        userEntity.setValue(User.qrModel?.exmoIdentifier, forKey: UserEntity.exmoIdentifier.rawValue)
//        userEntity.setValue(User.qrModel?.key, forKey: UserEntity.key.rawValue)
//        userEntity.setValue(User.qrModel?.secret, forKey: UserEntity.secret.rawValue)

        guard let walletEntityDescription = NSEntityDescription.entity(forEntityName: "Wallet", in: moc) else {
            return false
        }

        let walletEntity = WalletEntity(entity: walletEntityDescription, insertInto: moc)

        var currencies = NSSet()
        for currency in User.walletInfo.getCurrencies() {
            let c = WalletCurrencyEntity(context: moc)
            c.balance = currency.balance
            c.inOrders = currency.countInOrders
            c.currency = currency.currency
            c.isFavourite = currency.isFavourite
            c.wallet = walletEntity

            currencies.adding(c)
        }
        walletEntity.addToCurrencies(currencies)

        userEntity.wallet = walletEntity
        walletEntity.user = userEntity



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
        let uid = CacheManager.sharedInstance.appSettings.integer(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        deleteUser(uid: uid)
        CacheManager.sharedInstance.appSettings.removeObject(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
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
