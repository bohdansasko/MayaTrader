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
    var openedOrders: OrdersModel!
    var canceledOrders: OrdersModel!
    var dealsOrders: OrdersModel!
    
    func initHardcode() {
        // opened orders
        self.openedOrders = OrdersModel(orders: [
            OrderModel(orderType: .Buy, currencyPair: "BTC/USD", createdDate: Date(), price: 14234, quantity: 2, amount: 0.5123),
            OrderModel(orderType: .Sell, currencyPair: "BTC/EUR", createdDate: Date(), price: 44186, quantity: 100, amount: 1.5)
            ])
        
        // canceled orders
        let listOfCanceledOrders = [
            OrderModel(orderType: .Buy, currencyPair: "ZEC/USD", createdDate: Date(), price: 241.44356774, quantity: 192.76358764, amount: 0.79837947),
            OrderModel(orderType: .Sell, currencyPair: "LTC/USD", createdDate: Date(), price: 526.78165001, quantity: 23.77988769, amount: 0.15),
            OrderModel(orderType: .Buy, currencyPair: "ZEC/USD", createdDate: Date(), price: 241.44356774, quantity: 192.76358764, amount: 0.79837947),
            OrderModel(orderType: .Sell, currencyPair: "LTC/USD", createdDate: Date(), price: 526.78165001, quantity: 23.77988769, amount: 0.15)
        ]
        self.canceledOrders = OrdersModel(orders: listOfCanceledOrders)
        
        // deals orders
        let dealsOrders = [
            OrderModel(orderType: .Sell, currencyPair: "ETH/USD", createdDate: Date(), price: 986, quantity: 152.83, amount: 0.155)
        ]
        self.dealsOrders = OrdersModel(orders: dealsOrders)
    }
    
    init() {
        initHardcode()
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
        return self.openedOrders
    }
    
    func getCanceledOrders() -> OrdersModel {
        return self.canceledOrders
    }
    
    func getDealsOrders() -> OrdersModel {
        return self.dealsOrders
    }
    
    func cancelOpenedOrder(byIndex index: Int) {
        self.openedOrders.cancelOpenedOrder(byIndex: index)
    }
}
