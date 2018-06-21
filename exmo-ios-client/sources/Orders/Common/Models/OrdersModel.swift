//
//  OrdersModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class OrdersModel {
    // MARK: user types
    enum DisplayOrderType: Int {
        case Opened = 0
        case Canceled
        case Deals
    }
    
    private var orders: [OrderModel] = []
    
    init(orders: [OrderModel]) {
        self.orders = orders
    }

    
    func getCountOrders() -> Int {
        return orders.count
    }
    
    func getOrderBy(index: Int) -> OrderModel {
        return index > -1 && index < orders.count ? orders[index] : OrderModel()
    }
    
    func isDataExists() -> Bool {
        return orders.isEmpty == false
    }
    
    func cancelOpenedOrder(byIndex index: Int) {
        self.orders.remove(at: index)
    }
}
