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
        // do nothing
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
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPService.Notification.updateSubscription.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPService.Notification.purchaseError.name)
    }

    func unsubscribeEvents() {
        AppDelegate.notificationController.removeObserver(self)
    }
}

extension OrdersInteractor {
    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let subscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? ISubscriptionPackage else {
            print("\(#function) => can't convert notification container to IAPProduct")
            output.setSubscription(BasicAdsSubscriptionPackage())
            return
        }
        output.setSubscription(subscriptionPackage)
    }

    @objc
    func onPurchaseError(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let errorMsg = notification.userInfo?[IAPService.kErrorKey] as? String else {
            print("\(#function) => can't cast error message to String")
            output.setSubscription(BasicAdsSubscriptionPackage())
            return
        }
        output.purchaseError(reason: errorMsg)
    }
}
