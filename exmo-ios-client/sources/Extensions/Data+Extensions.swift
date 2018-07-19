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
    static let UserLoggedIn = Notification.Name("UserLoggedIn")
    static let UserLogout = Notification.Name("UserLogout")
    static let AppendAlert = Notification.Name("AppendAlert")
}
