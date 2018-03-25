//
//  ActiveOrdersModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class ActiveOrdersModel {
    private var orders: [ActiveOrderModel] = []
    
    init() {
        initWithTestData()
    }
    
    private func initWithTestData() {
        orders = [
            ActiveOrderModel(orderType: .Buy, currencyPair: "BTC/USD", createdDate: Date(), price: 14234, quantity: 2, amount: 0.5),
            ActiveOrderModel(orderType: .Buy, currencyPair: "BTC/EUR", createdDate: Date(), price: 44186, quantity: 100, amount: 1.5)
        ]
    }
    
    func getCountOrders() -> Int {
        return orders.count
    }
    
    func getOrderBy(index: Int) -> ActiveOrderModel {
        return index > -1 && index < orders.count ? orders[index] : ActiveOrderModel()
    }
    
    func isDataExists() -> Bool {
        return orders.isEmpty == false
    }
}
