//
//  CHLiteCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import ObjectMapper

struct CHLiteCurrencyModel {
    var stock    : CHStockExchange = .exmo
    var name     : String = ""
    var buyPrice : Double = 0.0
    var sellPrice: Double = 0.0
    var volume   : Double = 0.0
}

// MARK: - Mappable

extension CHLiteCurrencyModel: Mappable {
    
    init?(map: Map) {
        let requiredFields = [
            "currency_name", "buy_price",
            "sell_price"   , "vol"
        ]
        if !map.isJsonValid(by: requiredFields) {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        name      <-  map["currency_name"]
        buyPrice  <- (map["buy_price"], StringToDoubleTransform())
        sellPrice <- (map["sell_price"], StringToDoubleTransform())
        volume    <- (map["vol"], StringToDoubleTransform())
    }
    
}

// MARK: - Hashable

extension CHLiteCurrencyModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name.hashValue)
    }
    
}

