//
//  Session.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/7/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class Session {
    static var sharedInstance = Session()
    var user: User! // use local info or exmo info
    
    init() {
        login()
    }

    func login() {
        let uid = CacheManager.sharedInstance.appSettings.integer(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        let localUserExists = CacheManager.sharedInstance.userCoreManager.isUserExists(uid: uid)
        if localUserExists {
            user = CacheManager.sharedInstance.getUser()
        } else {
            user = CacheManager.sharedInstance.userCoreManager.createNewLocalUser()
        }
        NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
    }
    
    func logout() {
        CacheManager.sharedInstance.appSettings.set(IDefaultValues.UserUID.rawValue, forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        user = CacheManager.sharedInstance.getUser()
        NotificationCenter.default.post(name: .UserLogout, object: nil)
        NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
    }

    func isExmoAccountExists() -> Bool {
        return user.getIsLoginedAsExmoUser()
    }
    
    func getOrders() -> ActiveOrdersModel {
        return ActiveOrdersModel()
    }
}
