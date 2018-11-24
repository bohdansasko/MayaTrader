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

// @MARK: OrdersInteractorInput
extension OrdersInteractor: OrdersInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
    }
    
    func loadOrderByType(_ orderType: Orders.DisplayType) {
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
        output.onDidLoadOrders(loadedOrders: [:])
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
