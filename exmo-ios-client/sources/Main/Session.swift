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
    var user: UserModel! // use local info or exmo info
    
    init() {
        user = UserModel()
    }

    func logout() {
        user = UserModel()
        DataService.cache.deleteLastLoggedUser()
        NotificationCenter.default.post(name: .UserLogout, object: nil)
    }

    func isExmoAccountExists() -> Bool {
        return user.getIsExmoUIDSeted()
    }
}
