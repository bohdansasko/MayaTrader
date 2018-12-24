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
    var openedOrderType: Orders.DisplayType = .Open
}

// @MARK: OrdersInteractorInput
extension OrdersInteractor: OrdersInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self

        if Defaults.isUserLoggedIn() {
            loadOrderByType(openedOrderType)
        } else {
            onUserSignOut()
        }
    }
    
    func loadOrderByType(_ orderType: Orders.DisplayType) {
        if !Defaults.isUserLoggedIn() {
            onUserSignOut()
            return
        }
        
        openedOrderType = orderType
        switch orderType {
        case .Open: networkWorker.loadOpenOrders()
        case .Canceled: networkWorker.loadCanceledOrders()
        case .Deals: networkWorker.loadDeals()
        case .None: break
        }
    }
    
    func cancelOrder(id: Int64) {
        networkWorker.cancelOrder(id: id)
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
        output.orderCanceled(id: id)
    }
    
    func onDidCancelOrderFail(errorDescription: String) {
        print("Error \(errorDescription)")
    }
}
