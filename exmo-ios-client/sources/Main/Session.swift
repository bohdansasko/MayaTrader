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
    
    func getOpenedOrders() -> OrdersModel {
        let orders = [
            OrderModel(orderType: .Buy, currencyPair: "BTC/USD", createdDate: Date(), price: 14234, quantity: 2, amount: 0.5123),
            OrderModel(orderType: .Buy, currencyPair: "BTC/EUR", createdDate: Date(), price: 44186, quantity: 100, amount: 1.5)
        ]
        return OrdersModel(orders: orders)
    }
    
    func getCanceledOrders() -> OrdersModel {
        let orders = [
            OrderModel(orderType: .Sell, currencyPair: "ETH/USD", createdDate: Date(), price: 986, quantity: 152.83, amount: 0.155)
        ]
        return OrdersModel(orders: orders)
    }
    
    func getDealsOrders() -> OrdersModel {
        let orders = [
            OrderModel(orderType: .Buy, currencyPair: "ZEC/USD", createdDate: Date(), price: 241.44356774, quantity: 192.76358764, amount: 0.79837947),
            OrderModel(orderType: .Sell, currencyPair: "LTC/USD", createdDate: Date(), price: 526.78165001, quantity: 23.77988769, amount: 0.15),
            OrderModel(orderType: .Buy, currencyPair: "ZEC/USD", createdDate: Date(), price: 241.44356774, quantity: 192.76358764, amount: 0.79837947),
            OrderModel(orderType: .Sell, currencyPair: "LTC/USD", createdDate: Date(), price: 526.78165001, quantity: 23.77988769, amount: 0.15)
        ]
        return OrdersModel(orders: orders)
    }
}
