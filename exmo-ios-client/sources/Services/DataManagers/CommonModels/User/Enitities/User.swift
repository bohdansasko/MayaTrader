//
//  User.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper
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
    var walletInfo: WalletModel? = nil

    init() {
        // do nothing
    }

    init(userEntity: UserEntity) {
        self.walletInfo = WalletModel(walletEntity: userEntity.wallet!)
        self.qrModel = QRLoginModel(userEntity: userEntity)
        self.uid = Int(userEntity.uid)
    }

    required init?(map: Map) {
        // do nothing
    }

    func mapping(map: Map) {
        uid <- map["uid"]
    }

    func updateUserID() {
        let uidForCheck = CacheManager.sharedInstance.appSettings.integer(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        if CacheManager.sharedInstance.userCoreManager.isUserExists(uid: uidForCheck) {
            uid = uidForCheck
        }
    }

    func getUID() -> Int {
        return uid
    }

    func getIsLoginedAsExmoUser() -> Bool {
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
}
