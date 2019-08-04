//
//  OrderModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

struct CurrencySettings {
    let codeName: String
    let minQuantity: Double
    let maxQuantity: Double
    let minPrice: Double
    let maxPrice: Double
    let maxAmount: Double
    let minAmount: Double
    
    init(code: String, json: JSON) {
        codeName = code
        
        minQuantity = json["min_quantity"].doubleValue
        maxQuantity = json["max_quantity"].doubleValue
        
        minPrice = json["min_price"].doubleValue
        maxPrice = json["max_price"].doubleValue
        
        minAmount = json["min_amount"].doubleValue
        maxAmount = json["max_amount"].doubleValue
    }
}

// MARK: OrderCreateType
enum OrderCreateType: String {
    case buy = "buy"
    case sell = "sell"
    case marketBuy = "market_buy"
    case marketSell = "market_sell"
    case marketBuyTotal = "market_buy_total"
    case marketSellTotal = "market_sell_total"
}

// MARK: OrderSettings
struct OrderSettings : Mappable {
    var currencyPair: String
    var minQuantity: Double
    var maxQuantity: Double
    var minPrice: Double
    var maxPrice: Double
    var maxAmount: Double
    var minAmount: Double
    
    init() {
        self.currencyPair = ""
        self.minQuantity = 0.0
        self.maxQuantity = 0.0
        self.minPrice = 0.0
        self.maxPrice = 0.0
        self.minAmount = 0.0
        self.maxAmount = 0.0
    }
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        self.minQuantity <- map["min_quantity"]
        self.maxQuantity <- map["max_quantity"]
        
        self.minPrice <- map["min_price"]
        self.maxPrice <- map["max_price"]
        
        self.minAmount <- map["min_amount"]
        self.maxAmount <- map["max_amount"]
    }
}

// MARK: OrderModel
struct OrderModel: Mappable {
    var orderType: OrderActionType
    var currencyPair: String
    var createdDate: Date
    var price: Double
    var quantity: Double
    var amount: Double
    var id: Int64
    var createType: OrderCreateType = .marketBuyTotal
    
    init() {
        orderType = .none
        currencyPair = ""
        createdDate = Date()
        price = 0.0
        quantity = 0.0
        amount = 0.0
        id = 0
    }
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        createdDate <- (map["date"], DateTransform())
        id <- map["order_id"]
        currencyPair <- map["pair"]
        orderType <- (map["order_type"], TransformOrderType())
        price <- map["price"]
        quantity <- map["quantity"]
        amount <- map["amount"]
    }
    
    init(id: Int64, orderType: OrderActionType, currencyPair: String, createdDate: Date, price: Double, quantity: Double, amount: Double) {
        self.orderType = orderType
        self.currencyPair = currencyPair
        self.createdDate = createdDate
        self.price = price
        self.quantity = quantity
        self.amount = amount
        self.id = id
    }
    
    init(createType: OrderCreateType, currencyPair: String, price: Double, quantity: Double, amount: Double) {
        self.createType = createType
        self.currencyPair = currencyPair
        self.amount = amount
        self.price = price
        self.quantity = quantity
        
        self.id = -1
        self.createdDate = Date()
        
        switch self.createType {
        case .buy,
             .marketBuy,
             .marketBuyTotal:
            self.orderType = .buy
        case .sell,
             .marketSell,
             .marketSellTotal:
            self.orderType = .sell
        }
    }
    
    func getDisplayCurrencyPair() -> String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: self.currencyPair)
    }
    
    func getDateCreatedAsStr() -> String {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = "dd.MM.yyyy HH:mm"
        return dataFormat.string(from: self.createdDate)
    }
    
    func getPriceAsStr() -> String {
        return String(self.price)
    }
    
    
    func getQuantityAsStr() -> String {
        return String(self.quantity)
    }
    
    func getCreateTypeAsStr() -> String {
        return self.createType.rawValue
    }
    
    func getAmountAsStr() -> String {
        return Utils.getFormatedPrice(value: amount)
    }
}
