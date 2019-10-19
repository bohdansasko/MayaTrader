//
//  CHLiteCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Realm
import RealmSwift
import ObjectMapper

class CHLiteCurrencyModel: Object, Mappable {
    /// stockName + "_" + name
    @objc dynamic var id       : String = ""
    
    /// exmo, btc_trade, ..., etc
    @objc dynamic var stockName: String = ""
    
    /// BTC_USD, BTC_ETH, ..., etc
    @objc dynamic var name     : String = ""
    
    /// current max buying price
    @objc dynamic var buyPrice : Double = 0.0

    @objc dynamic var closeBuyPrice : Double = 0.0

    /// current min selling price
    @objc dynamic var sellPrice: Double = 0.0
    
    /// volume of all deals per 24 hours
    @objc dynamic var volume   : Double = 0.0
    
    var stock: CHStockExchange {
        return CHStockExchange(rawValue: stockName)!
    }
    
    var changes: Double {
        if closeBuyPrice == 0.0 {
            return 0.0
        }
        return (buyPrice - closeBuyPrice)/closeBuyPrice * 100
    }
    
    // MARK: - Realm
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    @objc override class func primaryKey() -> String? {
        return "id"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let mObj = object as? CHLiteCurrencyModel {
            return self.id == mObj.id
        }
        return false
    }
    
    // MARK: - Mappable
    
    required init?(map: Map) {
        let requiredFields = [
            "currency_name",
            "buy_price",
            "sell_price",
            "vol"
        ]
        
        if !map.isJsonValid(by: requiredFields) {
            assertionFailure("required")
            return nil
        }
        
        super.init()
    }
    
    func mapping(map: Map) {
        let strToDoubleTransform = StringToDoubleTransform.shared
        
        name          <-  map["currency_name"]
        stockName     <-  map["stock_exchange"]
        buyPrice      <- (map["buy_price"]      , strToDoubleTransform)
        sellPrice     <- (map["sell_price"]     , strToDoubleTransform)
        volume        <- (map["vol"]            , strToDoubleTransform)
        closeBuyPrice <- (map["close_buy_price"], strToDoubleTransform)
        
        id = stockName + "_" + name
    }
    
}

