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
    
    func onDidLoadSuccessCanceledOrders(orders: Orders)
    func onDidLoadFailsCanceledOrders(orders: Orders)
    
    func onDidLoadSuccessDeals(orders: Orders)
    func onDidLoadFailsDeals(orders: Orders)
}

protocol IOrdersListNetworkWorker {
    var delegate: IOrdersListNetworkWorkerDelegate? { get set }
    
    func loadAllOrders()
    func loadOpenOrders()
    func loadCanceledOrders()
    func loadDeals()
}
