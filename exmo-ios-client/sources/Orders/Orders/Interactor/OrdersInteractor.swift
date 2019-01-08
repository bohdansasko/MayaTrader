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

    var pendingOrdersForCancel: [Int64] = []
    var canceledOrders: [Int64] = []
}

// @MARK: OrdersInteractorInput
extension OrdersInteractor: OrdersInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
    }
    
    func loadOrderByType(_ orderType: Orders.DisplayType) {
        if !Defaults.isUserLoggedIn() {
            onUserSignOut()
            return
        }
        
        switch orderType {
        case .Open: networkWorker.loadOpenOrders()
        case .Canceled: networkWorker.loadCanceledOrders()
        case .Deals: networkWorker.loadDeals()
        case .None: break
        }
    }
    
    func cancelOrder(ids: [Int64]) {
        pendingOrdersForCancel = ids
        for id in ids {
            networkWorker.cancelOrder(id: id)
        }
    }
}

// MARK: load orders and display them
extension OrdersInteractor {
    func onUserSignOut() {
        var loadedOrders = [Orders.DisplayType : Orders]()
        loadedOrders[.Open] = Orders()
        loadedOrders[.Canceled] = Orders()
        loadedOrders[.Deals] = Orders()
        output.onDidLoadOrders(loadedOrders: loadedOrders)
    }
}

// @MARK: Load Open orders
extension OrdersInteractor {
    func onDidLoadSuccessOpenOrders(orders: Orders) {
        output.onDidLoadOrders(loadedOrders: [.Open : orders])
    }
    
    func onDidLoadFailsOpenOrders(orders: Orders) {
        print("onDidLoadFailsOpenOrders")
    }
}

// @MARK: Load Canceled orders
extension OrdersInteractor {
    func onDidLoadSuccessCanceledOrders(orders: Orders) {
        output.onDidLoadOrders(loadedOrders: [.Canceled : orders])
    }
    
    func onDidLoadFailsCanceledOrders(orders: Orders) {
        print("onDidLoadFailsCanceledOrders")
    }
}

// @MARK: Load deals
extension OrdersInteractor {
    func onDidLoadSuccessDeals(orders: Orders) {
        output.onDidLoadOrders(loadedOrders: [.Deals : orders])
    }
    
    func onDidLoadFailsDeals(orders: Orders) {
        print("onDidLoadFailsDeals")
    }
}

// @MARK: Cancel order
extension OrdersInteractor {
    func onDidCancelOrderSuccess(id: Int64) {
        canceledOrders.append(id)
        if pendingOrdersForCancel.count == canceledOrders.count {
            output.orderCanceled(ids: canceledOrders)
            pendingOrdersForCancel = []
            canceledOrders = []
        }
    }
    
    func onDidCancelOrderFail(errorDescription: String) {
        print("Error \(errorDescription)")
    }
}
