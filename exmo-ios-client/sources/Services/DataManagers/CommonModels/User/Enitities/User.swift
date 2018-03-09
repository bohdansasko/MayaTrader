//
//  User.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper

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
}
