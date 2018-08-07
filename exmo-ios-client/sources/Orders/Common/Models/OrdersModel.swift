//
//  OrdersModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrdersModel {
    // MARK: user types
    enum DisplayOrderType: Int {
        case Opened = 0
        case Canceled
        case Deals
    }
    
    private var orders: [OrderModel]
    
    init() {
        self.orders = []
    }
    
    convenience init(json: JSON) {
        self.init()
        self.parseJSON(json: json)
    }
    
    private func parseJSON(json: JSON) {
        guard let ordersArray = json.array else {
            return
        }
        
        for jsonOrder in ordersArray {
            if let map = jsonOrder.dictionaryObject {
                guard let order = OrderModel(JSON: map) else {
                    continue
                }
                
                self.orders.append(order)
            }
        }
    }
    
    init(orders: [OrderModel]) {
        self.orders = orders
    }
    
    func getCountOrders() -> Int {
        return self.orders.count
    }
    
    func getOrderBy(index: Int) -> OrderModel {
        return index > -1 && index < orders.count ? orders[index] : OrderModel()
    }
    
    func isDataExists() -> Bool {
        return orders.isEmpty == false
    }
    
    func removeItem(byIndex index: Int) {
        self.orders.remove(at: index)
    }
    
    func getOrders() -> [OrderModel] {
        return self.orders
    }
    
    func clear() {
        self.orders.removeAll()
    }
}
