//
//  ActiveOrderModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

struct ActiveOrderModel {
    private var orderType: ActiveOrderType
    private var currencyPair: String
    private var createdDate: Date
    private var price: Double
    private var quantity: Double
    private var amount: Double
    
    init() {
        orderType = .None
        currencyPair = ""
        createdDate = Date()
        price = 0.0
        quantity = 0.0
        amount = 0.0
    }

    init(orderType: ActiveOrderType, currencyPair: String, createdDate: Date, price: Double, quantity: Double, amount: Double) {
        self.orderType = orderType
        self.currencyPair = currencyPair
        self.createdDate = createdDate
        self.price = price
        self.quantity = quantity
        self.amount = amount
    }
    
    func getActiveOrderType() -> ActiveOrderType {
        return orderType
    }
    
    func getCurrencyPair() -> String {
        return currencyPair
    }
    
    func getDateCreatedAsStr() -> String {
        let df = DateFormatter()
        df.dateFormat = ""
        //createdDate.
        return "28.01.2018 06:47"
    }
    
    func getPrice() -> String {
        return String(price)
    }
    
    func getQuantity() -> String {
        return String(quantity)
    }
    
    func getAmount() -> String {
        return String(amount)
    }
    
    func getOperation() -> String {
        switch orderType {
        case .Buy: return "Buy"
        case .Sell: return "Sell"
        case .None: return "Unknown"
        }
    }
}
