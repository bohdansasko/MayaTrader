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
    
    lazy private var openedOrders = Orders()
    lazy private var canceledOrders = Orders()
    lazy private var dealsOrders = Orders()
    lazy private var searchCurrenciesContainer: [SearchCurrencyPairModel] = []
    
    private var alerts: [AlertItem] = []

    init() {
        self.user = User()
        initHardcode()
    }

    //
    // @common getters
    //
    func getSearchCurrenciesContainer() -> [SearchCurrencyPairModel] {
        return self.searchCurrenciesContainer
    }
    
    func loadCurrenciesPairsWithPrice() {
        guard let currencies = AppDelegate.exmoController.loadTickerData() else {
            AppDelegate.notificationController.postBroadcastMessage(name: .LoadTickerFailed)
            return
        }
        searchCurrenciesContainer(data: currencies)
        AppDelegate.notificationController.postBroadcastMessage(name: .LoadTickerSuccess, data: [ "SearchCurrencyPairsContainer" : currencies])
    }
    
    private func searchCurrenciesContainer(data: [SearchCurrencyPairModel]) {
        self.searchCurrenciesContainer = data
    }
}

//
// MARK: Account
//
extension Session {
    func roobikLogin() {
        AppDelegate.roobikController.signIn()
    }
    
    func exmoLogout() {
        AppDelegate.cacheController.removeUser()
        
        self.user = User()
        
        self.openedOrders.clear()
        self.canceledOrders.clear()
        self.dealsOrders.clear()
        
        AppDelegate.notificationController.postBroadcastMessage(name: .UserSignOut)
    }
    
    func setUserModel(userData: User, shouldSaveUserInCache: Bool) {
        self.user = userData
        
        let userInfoFromCache = AppDelegate.cacheController.getUser()
        if shouldSaveUserInCache && userInfoFromCache != nil {
            self.user.walletInfo.merge(userInfoFromCache!.walletInfo)
            let isUserSavedToLocalStorage = AppDelegate.cacheController.userCoreManager.saveUserData(user: userData)
            if isUserSavedToLocalStorage {
                print("user info cached")
            }
        }
        
        self.loadAllOrders()
        
        AppDelegate.notificationController.postBroadcastMessage(name: .UserSignIn)
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
    func loadCurrencyPairSettings(_ name: String) {
        guard let settings = AppDelegate.exmoController.loadCurrencyPairSettings(name) else {
            AppDelegate.notificationController.postBroadcastMessage(name: .LoadCurrencySettingsFailed)
            return
        }
        
        AppDelegate.notificationController.postBroadcastMessage(name: .LoadCurrencySettingsSuccess, data: ["data": settings])
    }
    
    func loadAllOrders() {
        self.loadOrders(orderType: .Open, serverType: .Exmo)
        self.loadOrders(orderType: .Deals, serverType: .Exmo)
        self.loadOrders(orderType: .Canceled, serverType: .Exmo)
    }
    
    func loadOrders(orderType: Orders.DisplayType, serverType: ServerType = .Exmo) {
        switch orderType {
        case .Open:
            switch serverType {
            case .Exmo:
                guard let orders = AppDelegate.exmoController.loadOpenOrders(limit: 100, offset: 0) else {
                    return
                }
                self.setOpenOrders(orders: orders)
//                AppDelegate.notificationController.postBroadcastMessage(name: .OpenOrdersLoaded)
                break
            case .Roobik:
                break
            }
            break
        case .Canceled:
            switch serverType {
            case .Exmo:
                guard let orders = AppDelegate.exmoController.loadCanceledOrders(limit: 100, offset: 0) else {
                    print("can't load canceled orders")
                    return
                }
                self.setCanceledOrders(orders: orders)
//                AppDelegate.notificationController.postBroadcastMessage(name: .CanceledOrdersLoaded)
                break
            case .Roobik:
                break
            }
            break
        case .Deals:
            switch serverType {
            case .Exmo:
                guard let orders = AppDelegate.exmoController.loadDeals(limit: 100, offset: 0) else {
                    return
                }
                self.setDeals(orders: orders)
//                AppDelegate.notificationController.postBroadcastMessage(name: .DealsOrdersLoaded)
                break
            case .Roobik:
                break
            }
            break
        default:
            // do nothing
            break
        }
    }
    
    func appendOrder(orderModel: OrderModel) {
//        AppDelegate.notificationController.postBroadcastMessage(name: .AppendOrder, data: ["data": orderModel])
        self.openedOrders.append(orderModel: orderModel)
    }
    
    private func setOpenOrders(orders: Orders) {
        self.openedOrders = orders
    }

    private func setCanceledOrders(orders: Orders) {
        self.canceledOrders = orders
    }

    private func setDeals(orders: Orders) {
        self.dealsOrders = orders
    }

    func createOrder(order: OrderModel) -> (Bool, Int64) {
        guard let createResult = AppDelegate.exmoController.createOrder(pair: order.getCurrencyPair(), quantity: order.getAmount(), price: order.getPrice(), type: order.getCreateTypeAsStr()) else {
            return (false, -1)
        }
        
        if createResult.result {
            return (true, createResult.id)
        }
        return (false, -1)
    }
    
    func cancelOpenOrder(id: Int64, byIndex index: Int) -> Bool {
        if AppDelegate.exmoController.cancelOrder(id: id) {
            self.openedOrders.removeItem(byIndex: index)
            return true
        }
        return false
    }
    
    //
    // @MARK: getters
    //
    func getOpenOrders() -> Orders {
        return self.openedOrders
    }
    
    func getCanceledOrders() -> Orders {
        return self.canceledOrders
    }
    
    func getDealsOrders() -> Orders {
        return self.dealsOrders
    }
    
    func isOpenOrdersLoaded() -> Bool {
        return self.openedOrders.isDataExists()
    }
    
    func isCanceledOrdersLoaded() -> Bool {
        return self.canceledOrders.isDataExists()
    }
    
    func isDealsOrdersLoaded() -> Bool {
        return self.dealsOrders.isDataExists()
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
        self.openedOrders = Orders(orders: [
            OrderModel(id: 1, orderType: .Buy, currencyPair: "BTC/USD", createdDate: Date(), price: 14234, quantity: 2, amount: 0.5123),
            OrderModel(id: 2, orderType: .Sell, currencyPair: "BTC/EUR", createdDate: Date(), price: 44186, quantity: 100, amount: 1.5)
            ])
        
        // canceled orders
        let listOfCanceledOrders = [
            OrderModel(id: 3, orderType: .Buy, currencyPair: "ZEC/USD", createdDate: Date(), price: 241.44356774, quantity: 192.76358764, amount: 0.79837947),
            OrderModel(id: 4, orderType: .Sell, currencyPair: "LTC/USD", createdDate: Date(), price: 526.78165001, quantity: 23.77988769, amount: 0.15),
            OrderModel(id: 5, orderType: .Buy, currencyPair: "ZEC/USD", createdDate: Date(), price: 241.44356774, quantity: 192.76358764, amount: 0.79837947),
            OrderModel(id: 6, orderType: .Sell, currencyPair: "LTC/USD", createdDate: Date(), price: 526.78165001, quantity: 23.77988769, amount: 0.15)
        ]
        self.canceledOrders = Orders(orders: listOfCanceledOrders)
        
        // deals orders
        let dealsOrders = [
            OrderModel(id: 7, orderType: .Sell, currencyPair: "ETH/USD", createdDate: Date(), price: 986, quantity: 152.83, amount: 0.155)
        ]
        self.dealsOrders = Orders(orders: dealsOrders)
        
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
