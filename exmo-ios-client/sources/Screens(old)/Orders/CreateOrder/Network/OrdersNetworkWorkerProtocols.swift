//
//  OrdersNetworkWorkerProtocols.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation


protocol IOrdersNetworkWorkerDelegate: class {
    func onDidCreateOrderSuccess()
    func onDidCreateOrderFail(errorMessage: String)
}

protocol IOrdersNetworkWorker: class {
    var delegate: IOrdersNetworkWorkerDelegate? { get set }
    
    func createOrder(order: OrderModel)
}
