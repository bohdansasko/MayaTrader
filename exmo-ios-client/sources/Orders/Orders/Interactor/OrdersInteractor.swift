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
}

// MARK: OrdersInteractorInput
extension OrdersInteractor: OrdersInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
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
