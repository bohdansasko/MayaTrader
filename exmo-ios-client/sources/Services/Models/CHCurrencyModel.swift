//
//  CHCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/28/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Realm
import RealmSwift
import ObjectMapper

final class CHCurrencyModel: CHLiteCurrencyModel {
    /// middle deal price for 24 hours
    var avg         : Double = 0.0

    var closeByPrice: Double = 0.0

    /// max deal price for 24 hours
    var high        : Double = 0.0
    /// min deal price for 24 hours
    var low         : Double = 0.0
    /// last deal price
    var lastTrade   : Double = 0.0
    /// sum of all deals per 24 hours
    var volCurr     : Double = 0.0
    /// date & time of update data
    var updated     : TimeInterval = 0.0
    
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
    
    // MARK: - Mappable
    
    required init?(map: Map) {
        let requiredFields = [
            "avg",
            "close_buy_price",
            "low",
            "high",
            "last_trade",
            "vol_curr",
            "updated"
        ]
        
        if !map.isJsonValid(by: requiredFields) {
            assertionFailure("required")
            return nil
        }
        
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        let strToDoubleTransform = StringToDoubleTransform.shared
        
        avg          <- (map["avg"]            , strToDoubleTransform)
        closeByPrice <- (map["close_buy_price"], strToDoubleTransform)
        low          <- (map["low"]            , strToDoubleTransform)
        high         <- (map["high"]           , strToDoubleTransform)
        lastTrade    <- (map["last_trade"]     , strToDoubleTransform)
        volCurr      <- (map["vol_curr"]       , strToDoubleTransform)
        updated      <- (map["updated"]        , strToDoubleTransform)
    }
    
}
