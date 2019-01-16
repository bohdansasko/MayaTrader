//
//  OrdersInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import Alamofire

class OrdersInteractor: IOrdersListNetworkWorkerDelegate {
    weak var output: OrdersInteractorOutput!
    var loadedOrders: [Orders.DisplayType : Orders] = [:]
    var networkWorker: IOrdersListNetworkWorker!

    deinit {
        unsubscribeEvents()
    }
}

// MARK: OrdersInteractorInput
extension OrdersInteractor: OrdersInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
        subscribeOnIAPEvents()
    }

    func viewWillAppear() {
//        let shouldShowAds = !IAPService.shared.isProductPurchased(.advertisements)
//        output.setAdsActive(shouldShowAds)
    }
    
    func loadOrderByType(_ orderType: Orders.DisplayType) {
        if !Defaults.isUserLoggedIn() {
            onUserSignOut()
            return
        }
        print("loadOrderByType => \(orderType)")

        switch orderType {
        case .open: networkWorker.loadOpenOrders()
        case .canceled: networkWorker.loadCanceledOrders()
        case .deals: networkWorker.loadDeals()
        case .none: break
        }
    }
    
    func cancelOrder(ids: [Int64]) {
        networkWorker.cancelOrders(ids: ids)
    }
}

// MARK: load orders and display them
extension OrdersInteractor {
    func onUserSignOut() {
        var loadedOrders = [Orders.DisplayType : Orders]()
        loadedOrders[.open] = Orders()
        loadedOrders[.canceled] = Orders()
        loadedOrders[.deals] = Orders()
        output.onDidLoadOrders(loadedOrders: loadedOrders)
    }
}

// MARK: Load Open orders
extension OrdersInteractor {
    func onDidLoadSuccessOpenOrders(orders: Orders) {
        print("OrdersInteractor => onDidLoadSuccessOpenOrders")
        output.onDidLoadOrders(loadedOrders: [.open : orders])
    }
    
    func onDidLoadFailsOpenOrders(orders: Orders) {
        print("onDidLoadFailsOpenOrders")
    }
}

// MARK: Load Canceled orders
extension OrdersInteractor {
    func onDidLoadSuccessCanceledOrders(orders: Orders) {
        output.onDidLoadOrders(loadedOrders: [.canceled : orders])
    }
    
    func onDidLoadFailsCanceledOrders(orders: Orders) {
        print("onDidLoadFailsCanceledOrders")
    }
}

// MARK: Load deals
extension OrdersInteractor {
    func onDidLoadSuccessDeals(orders: Orders) {
        output.onDidLoadOrders(loadedOrders: [.deals : orders])
    }
    
    func onDidLoadFailsDeals(orders: Orders) {
        print("onDidLoadFailsDeals")
    }
}

// MARK: Cancel order
extension OrdersInteractor {
    func onDidCancelOrderSuccess(id: Int64) {
        print("OrdersInteractor => has cancelled order \(id)")
        output.orderCanceled(ids: [id])
    }

    func onDidCancelOrdersSuccess(ids: [Int64]) {
        print("OrdersInteractor => has cancelled orders \(ids)")
        output.orderCanceled(ids: ids)
    }
    
    func onDidCancelOrderFail(errorDescription: String) {
        print("Error \(errorDescription)")
    }
}


extension OrdersInteractor {
    func subscribeOnIAPEvents() {
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchased(_ :)),
                name: IAPService.Notification.purchased.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductExpired(_ :)),
                name: IAPService.Notification.expired.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductNotPurchased(_ :)),
                name: IAPService.Notification.notPurchased.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseSuccess(_ :)),
                name: IAPService.Notification.purchaseSuccess.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseError(_ :)),
                name: IAPService.Notification.purchaseError.name)
    }

    func unsubscribeEvents() {
        AppDelegate.notificationController.removeObserver(self)
    }
}


extension OrdersInteractor {
    @objc
    func onProductPurchased(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)) => notification IAPProduct is \(product.rawValue)")
        output.setAdsActive(false)
    }

    @objc
    func onProductExpired(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
        output.setAdsActive(true)
    }

    @objc
    func onProductNotPurchased(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
        output.setAdsActive(true)
    }

    @objc
    func onProductPurchaseSuccess(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
        output.setAdsActive(false)
    }

    @objc
    func onProductPurchaseError(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
        output.setAdsActive(true)
    }
}
