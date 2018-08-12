//
//  OrderModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper

//
// @MARK: OrderCreateType
//
enum OrderCreateType: String {
    case None = "None"
    case Buy = "buy"
    case Sell = "sell"
    case MarketBuy = "market_buy"
    case MarketSell = "market_sell"
    case MarketBuyTotal = "market_buy_total"
    case MarketSellTotal = "market_sell_total"
}

//
// @MARK: OrderSettings
//
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

//
// @MARK: TransformOrderType
//
class TransformOrderType : TransformType {
    typealias Object = OrderActionType
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        guard let strValue = value as? String else {
            return nil
        }
        
        switch strValue {
        case "buy":
            return OrderActionType.Buy
        case "sell":
            return OrderActionType.Sell
        default:
            return nil
        }
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return nil
    }
}

//
// @MARK: OrderModel
//
struct OrderModel: Mappable {
    private var orderType: OrderActionType
            var currencyPair: String
    private var createdDate: Date
    private var price: Double
    private var quantity: Double
    private var amount: Double
    private var id: Int64
    private var createType: OrderCreateType = .None
    
    init() {
        orderType = .None
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
        case .Buy,
             .MarketBuy,
             .MarketBuyTotal:
            self.orderType = .Buy
        case .Sell,
             .MarketSell,
             .MarketSellTotal:
            self.orderType = .Sell
        case .None:
            self.orderType = .None
        }
    }
    
    mutating func setOrderId(id: Int64) {
        self.id = id
    }
    
    func getId() -> Int64 {
        return self.id
    }
    
    func getOrderActionType() -> OrderActionType {
        return self.orderType
    }
    
    func getCurrencyPair() -> String {
        return self.currencyPair
    }
    
    func getDisplayCurrencyPair() -> String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: self.currencyPair)
    }
    
    func getDateCreatedAsStr() -> String {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dataFormat.string(from: self.createdDate)
    }
    
    func getPrice() -> Double {
        return self.price
    }

    func getPriceAsStr() -> String {
        return String(self.price)
    }
    
    func getQuantity() -> Double {
        return self.quantity
    }
    
    func getQuantityAsStr() -> String {
        return String(self.quantity)
    }
    
    func getCreateTypeAsStr() -> String {
        return self.createType.rawValue
    }
    
    func getAmount() -> Double {
        return self.amount
    }
    
    func getAmountAsStr() -> String {
        return String(self.amount)
    }
    
    func getOrderActionTypeAsStr() -> String {
        switch self.orderType {
        case .Buy: return "Buy"
        case .Sell: return "Sell"
        case .None: return "Unknown"
        }
    }
}
