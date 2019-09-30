//
//  CHCurrencyCandleModel.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/30/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import ObjectMapper

struct CHCandleModel {
    var timestamp: TimeInterval = 0.0
    var open     : Double       = 0.0
    var close    : Double       = 0.0
    var high     : Double       = 0.0
    var low      : Double       = 0.0
    var volume   : Double       = 0.0
}

// MARK: - Mappable

extension CHCandleModel: Mappable {
    
    init?(map: Map) {
        let requiredFields = [
            "timestamp",
            "open",
            "close",
            "high",
            "low",
            "volume"
        ]
        
        if !map.isJsonValid(by: requiredFields) {
            assertionFailure("required")
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        timestamp   <- map["timestamp"]
        open        <- map["open"]
        close       <- map["close"]
        low         <- map["low"]
        volume      <- map["volume"]
    }
    
}
