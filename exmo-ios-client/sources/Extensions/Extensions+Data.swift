//
//  NSData+Extensions.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

extension Data {
    func getJsonFromData() -> NSDictionary? {
        if let json = try! JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? NSDictionary {
            return json
        } else {
            return nil
        }
    }
}

extension Notification.Name {
    static let UserSignIn = Notification.Name("UserSignIn")
    static let UserSignOut = Notification.Name("UserSignOut")

    static let AppendAlert = Notification.Name("AppendAlert")
    static let UpdateAlert = Notification.Name("UpdateAlert")
    static let DeleteAlert = Notification.Name("DeleteAlert")
}
