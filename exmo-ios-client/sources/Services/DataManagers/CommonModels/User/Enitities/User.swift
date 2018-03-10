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
    private var uid: Int! = 0 {
        didSet {
            isExmoUIDSeted = true
        }
    }
    private var isExmoUIDSeted = false

    var qrModel: QRLoginModel?
    var walletInfo: WalletModel!

    init() {
        walletInfo = WalletModel()
    }

    init(userEntity: UserEntity) {
        self.uid = Int(userEntity.uid)
        walletInfo = WalletModel(walletEntity: userEntity.wallet!)
        self.qrModel = QRLoginModel(userEntity: userEntity)
    }

    required init?(map: Map) {
        walletInfo = WalletModel()
    }

    func mapping(map: Map) {
        uid <- map["uid"]
    }

    func updateUserID() {
        let uidForCheck = CacheManager.sharedInstance.appSettings.integer(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        if CacheManager.sharedInstance.userCoreManager.isUserExists(uid: uidForCheck) {
            uid = uidForCheck
            isExmoUIDSeted = true
        }
    }

    func getUID() -> Int {
        return uid
    }

    func getIsExmoUIDSeted() -> Bool {
        return isExmoUIDSeted
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
