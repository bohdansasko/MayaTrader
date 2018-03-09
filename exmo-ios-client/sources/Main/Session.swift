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
        user = CacheManager.sharedInstance.getUser()
    }

    func logout() {
        user = User()
        CacheManager.sharedInstance.userCoreManager.deleteLastLoggedUser()
        NotificationCenter.default.post(name: .UserLogout, object: nil)
    }

    func isExmoAccountExists() -> Bool {
        return user.getIsExmoUIDSeted()
    }
}
