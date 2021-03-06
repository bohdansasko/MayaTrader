//
//  OrdersListNetworkProtocols.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol IOrdersListNetworkWorkerDelegate: class {
    func onDidLoadSuccessOpenOrders(orders: Orders)
    func onDidLoadFailsOpenOrders(orders: Orders)
    
    func onDidLoadSuccessCancelledOrders(orders: Orders)
    func onDidLoadFailsCancelledOrders(orders: Orders)
    
    func onDidLoadSuccessDeals(orders: Orders)
    func onDidLoadFailsDeals(orders: Orders)
    
    func onDidCancelOrderSuccess(id: Int64)
    func onDidCancelOrdersSuccess(ids: [Int64])
    func onDidCancelOrderFail(errorDescription: String)
}

protocol IOrdersListNetworkWorker {
    var delegate: IOrdersListNetworkWorkerDelegate? { get set }
    
    func loadAllOrders()
    func loadOpenOrders()
    func loadCancelledOrders()
    func loadDeals()
    
    func cancelOrder(id: Int64)
    func cancelOrders(ids: [Int64])
}
