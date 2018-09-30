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
    static let UserFailSignIn = Notification.Name("UserFailSignIn")
    static let UserSignOut = Notification.Name("UserSignOut")

    static let OpenOrdersLoaded = Notification.Name("CanceledOrdersLoaded")
    static let CanceledOrdersLoaded = Notification.Name("CanceledOrdersLoaded")
    static let DealsOrdersLoaded = Notification.Name("CanceledOrdersLoaded")
    
    static let AppendAlert = Notification.Name("AppendAlert")
    static let UpdateAlert = Notification.Name("UpdateAlert")
    static let DeleteAlert = Notification.Name("DeleteAlert")
    
    static let AppendOrder = Notification.Name("AppendOrder")
    
    static let LoadTickerSuccess = Notification.Name("LoadTickerSuccess")
    static let LoadTickerFailed = Notification.Name("LoadTickerFailed")
    
    static let LoadCurrencySettingsSuccess = Notification.Name("LoadCurrencySettingsSuccess")
    static let LoadCurrencySettingsFailed = Notification.Name("LoadCurrencySettingsFailed")
}
