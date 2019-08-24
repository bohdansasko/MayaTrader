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
        let strToDoubleTransform = StringToDoubleTransform.shared

        name      <-  map["currency_name"]
        stock     <- (map["stock_exchange"], EnumTransform<CHStockExchange>())
        buyPrice  <- (map["buy_price"] , strToDoubleTransform)
        sellPrice <- (map["sell_price"], strToDoubleTransform)
        volume    <- (map["vol"]       , strToDoubleTransform)
    }
    
}

// MARK: - Hashable

extension CHLiteCurrencyModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name.hashValue)
    }
    
}

