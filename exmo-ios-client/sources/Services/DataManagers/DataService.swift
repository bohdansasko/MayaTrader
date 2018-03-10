//
//  DataService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class CacheManager {
    static var sharedInstance = CacheManager()
    
    var appSettings = UserDefaults.standard
    var userCoreManager = UserCoreDataEngine.sharedInstance
    var walletCoreManager = WalletCoreDataEngine.sharedInstance
    
    func getUser() -> User {
        return User()
    }
}
