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

final class CHLiteCurrencyModel: Object, Mappable {
    @objc dynamic var id       : Int = 0
    @objc dynamic var stockName: String = ""
    @objc dynamic var name     : String = ""
    @objc dynamic var buyPrice : Double = 0.0
    @objc dynamic var sellPrice: Double = 0.0
    @objc dynamic var volume   : Double = 0.0
    
    var stock: CHStockExchange {
        return CHStockExchange(rawValue: stockName)!
    }
    
    // MARK: Realm
    
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
            return self.name == mObj.name && self.stockName == mObj.stockName
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
        
        name      <-  map["currency_name"]
        stockName <-  map["stock_exchange"]
        buyPrice  <- (map["buy_price"]     , strToDoubleTransform)
        sellPrice <- (map["sell_price"]    , strToDoubleTransform)
        volume    <- (map["vol"]           , strToDoubleTransform)
        
        id = stockName.hashValue & name.hashValue
    }
    
}

