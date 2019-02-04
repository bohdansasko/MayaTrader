//
//  Orders.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON

class Orders {
    // MARK: user types
    enum DisplayType: Int {
        case none = -1
        case open = 0
        case cancelled
        case deals
    }
    
    private var orders: [OrderModel]
    private(set) var displayType: DisplayType = .none
    
    init() {
        self.orders = []
    }
    
    convenience init(json: JSON, displayType: DisplayType = .none) {
        self.init()
        self.displayType = displayType
        self.parseJSON(json: json)
    }
    
    private func parseJSON(json: JSON) {
        if displayType == .none {
            print("order display type == none")
            return
        }
        
        if let ordersArray = json.array {
            for jsonOrder in ordersArray {
                if let map = jsonOrder.dictionaryObject {
                    guard let order = OrderModel(JSON: map) else {
                        continue
                    }
                    self.orders.append(order)
                }
            }
            return
        }

        if let ordersDictionary = json.dictionary {
            let idKey = displayType == .deals ? "trade_id" : "order_id"
            let orderTypeKey = displayType == .cancelled ? "order_type" : "type"
            let dateKey = displayType == .open ? "created" : "date"

            for (_, orders) in ordersDictionary {
                for order in orders.arrayValue {
                    guard let map = order.dictionary, !map.isEmpty else {
                        continue
                    }

                    guard let id = map[idKey]?.int64Value,
                          let date = map[dateKey]?.doubleValue,
                          let pair = map["pair"]?.stringValue,
                          let price = map["price"]?.doubleValue,
                          let quantity = map["quantity"]?.doubleValue,
                          let amount = map["amount"]?.doubleValue,
                          let orderType: OrderActionType = map[orderTypeKey]?.stringValue == OrderActionType.sell.rawValue
                            ? OrderActionType.sell
                            : map[orderTypeKey]?.stringValue == OrderActionType.buy.rawValue
                                ? OrderActionType.buy
                                : OrderActionType.none,
                        orderType != .none
                    else {
                        continue
                    }
                    
                    let model = OrderModel(id: id, orderType: orderType, currencyPair: pair, createdDate: Date(timeIntervalSince1970: date), price: price, quantity: quantity, amount: amount)
                    self.orders.append(model)
                }
            }
        }
    }
    
    func append(orderModel: OrderModel) {
        self.orders.insert(orderModel, at: 0)
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
        if isValidIndex(index: index) {
            self.orders.remove(at: index)
        }
    }
    
    func isValidIndex(index: Int) -> Bool {
        return index > -1 && index < self.orders.count
    }
    
    func getOrders() -> [OrderModel] {
        return self.orders
    }
    
    func clear() {
        self.orders.removeAll()
    }
}
