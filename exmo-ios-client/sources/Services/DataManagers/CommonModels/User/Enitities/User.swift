//
//  User.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON
import CoreData

class User: Mappable {
    private var _uid: Int = 0
    var uid: Int! {
        set {
            _uid = newValue
        }
        get { return _uid }
    }

    var qrModel: QRLoginModel? = nil
    var walletInfo: WalletModel = WalletModel()

    init() {
        // do nothing
    }

    init(userEntity: UserEntity) {
        if userEntity.wallet != nil {
            self.walletInfo = WalletModel(walletEntity: userEntity.wallet!)
        }
        if userEntity.exmoIdentifier != nil {
            self.qrModel = QRLoginModel(userEntity: userEntity)
        }
        self.uid = Int(userEntity.uid)
    }

    required init?(map: Map) {
        if !map["uid"].isKeyPresent {
            return nil
        }
        
        if let walletInfo = WalletModel(JSON: map.JSON) {
            self.walletInfo = walletInfo
        }
    }

    func mapping(map: Map) {
        uid <- map["uid"]
    }

    func updateUserID() {
        let uidForCheck = AppDelegate.cacheController.appSettings.integer(forKey: DefaultStringValues.LastLoginedUID.rawValue)
        if AppDelegate.cacheController.userCoreManager.isUserExists(uid: uidForCheck) {
            uid = uidForCheck
        }
    }

    func getUID() -> Int {
        return uid
    }

    func getIsLoginedAsExmoUserObject() -> Bool {
        return self.qrModel?.isValidate() ?? false
    }

    func getUserEntity(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) -> UserEntity {
        let userEntity = UserEntity(entity: entity, insertInto: context)
        userEntity.setValue(self.getUID(), forKey: UserEntityKeys.uid.rawValue)
        userEntity.setValue(self.qrModel?.exmoIdentifier, forKey: UserEntityKeys.exmoIdentifier.rawValue)
        userEntity.setValue(self.qrModel?.key, forKey: UserEntityKeys.key.rawValue)
        userEntity.setValue(self.qrModel?.secret, forKey: UserEntityKeys.secret.rawValue)
        return userEntity
    }
    
    func getWalletInfo() -> WalletModel {
        return self.walletInfo
    }
}
