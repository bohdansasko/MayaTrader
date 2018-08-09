//
//  DataService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class CacheManager {
    var appSettings = UserDefaults.standard
    var userCoreManager = UserCoreDataEngine.sharedInstance
    var walletCoreManager = WalletCoreDataEngine.sharedInstance
    
    func isUserInfoExistsInCache() -> Bool {
        let uid = appSettings.integer(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        return userCoreManager.isUserExists(uid: uid)
    }
    
    func getUser() -> User? {
        let uid = self.appSettings.integer(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        let userEntity = self.userCoreManager.loadUserData(uid: uid)
        if userEntity != nil {
            return User(userEntity: userEntity!)
        }
        return nil
    }
    
    func removeUser() {
        self.appSettings.set(IDefaultValues.UserUID.rawValue, forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        self.userCoreManager.deleteLastLoggedUser()
    }
}
