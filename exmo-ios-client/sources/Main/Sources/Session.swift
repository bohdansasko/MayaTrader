//
//  Session.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/7/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class Session {
    enum ServerType {
        case Exmo
        case Roobik
    }
    
    private var user: User! // use local info or exmo info
    
    private var openedOrders: OrdersModel!
    private var canceledOrders: OrdersModel!
    private var dealsOrders: OrdersModel!
    private var searchCurrenciesContainer: [SearchCurrencyPairModel]!
    
    private var alerts: [AlertItem] = []

    init() {
        self.user = User()
        self.initHardcode()
    }

    //
    // @common getters
    //
    func getSearchCurrenciesContainer() -> [SearchCurrencyPairModel] {
        return self.searchCurrenciesContainer
    }
}

//
// MARK: Account
//
extension Session {
    func login(serverType: ServerType) {
        switch serverType {
        case .Exmo:
            let uid = CacheManager.sharedInstance.appSettings.integer(forKey: AppSettingsKeys.LastLoginedUID.rawValue)
            let localUserExists = CacheManager.sharedInstance.userCoreManager.isUserExists(uid: uid)
            if localUserExists {
                self.user = CacheManager.sharedInstance.getUser()
                AppDelegate.notificationController.postBroadcastMessage(name: .UserSignIn)
            }
//            else {
//                self.user = CacheManager.sharedInstance.userCoreManager.createNewLocalUser()
//            }
        case .Roobik:
            AppDelegate.roobikController.signIn()
            break
        }
    }
    
    func logout() {
        CacheManager.sharedInstance.appSettings.set(IDefaultValues.UserUID.rawValue, forKey: AppSettingsKeys.LastLoginedUID.rawValue)
        self.user = CacheManager.sharedInstance.getUser()
        
        AppDelegate.notificationController.postBroadcastMessage(name: .UserSignOut)
        AppDelegate.notificationController.postBroadcastMessage(name: .UserSignIn)
    }
    
    func updateUserInfo(userData: User) {
        self.user = userData
    }
    
    func isExmoAccountExists() -> Bool {
        return self.user.getIsLoginedAsExmoUser()
    }
    
    func getUser() -> User {
        return self.user
    }
}

//
// MARK: Orders
//
extension Session {
    func cancelOpenedOrder(byIndex index: Int) {
        self.openedOrders.cancelOpenedOrder(byIndex: index)
        // TODO Orders: send message to server
    }
    
    //
    // @MARK: getters
    //
    func getOpenedOrders() -> OrdersModel {
        return self.openedOrders
    }
    
    func getCanceledOrders() -> OrdersModel {
        return self.canceledOrders
    }
    
    func getDealsOrders() -> OrdersModel {
        return self.dealsOrders
    }
}

//
// MARK: Alerts
//
extension Session {
    func appendAlert(alertItem: AlertItem) {
        AppDelegate.notificationController.postBroadcastMessage(name: .AppendAlert, data: ["alertData": alertItem])
        self.alerts.append(alertItem)
    }
    
    func updateAlert(alertItem: AlertItem) {
        guard var foundAlert = self.alerts.first(where: { $0.id == alertItem.id }) else {
            return
        }
        foundAlert = alertItem
        AppDelegate.notificationController.postBroadcastMessage(name: .UpdateAlert, data: ["alertData": alertItem])
    }
    
    func deleteAlert(alertId: String) {
        AppDelegate.roobikController.deleteAlert(alertId: alertId)
    }
    
    func appendAlerts(alerts: [AlertItem]) {
        self.alerts += alerts
        print("call appendAlerts(...)")
    }
    
    func getAlerts() -> [AlertItem] {
        return self.alerts
    }
}

//
// MARK: Test code
//
extension Session {
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
        
        self.searchCurrenciesContainer = [
            SearchCurrencyPairModel(id: 1, name: "BTC/USD", price: 7809.976),
            SearchCurrencyPairModel(id: 2, name: "BTC/EUR", price: 6009.65),
            SearchCurrencyPairModel(id: 3, name: "BTC/UAH", price: 51090.0),
            SearchCurrencyPairModel(id: 4, name: "EUR/USD", price: 109.976),
            SearchCurrencyPairModel(id: 5, name: "UAH/USD", price: 709.976),
            SearchCurrencyPairModel(id: 6, name: "UAH/BTC", price: 809.976),
            SearchCurrencyPairModel(id: 7, name: "EUR/BTC", price: 9871.976)
        ]
    }
}
