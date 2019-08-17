//
//  TickerCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper

struct TickerCurrencyModel {
    var code: String = ""
    var buyPrice: Double = 0.0
    var sellPrice: Double = 0.0
    var lastTrade: Double = 0.0
    var high: Double = 0.0
    var low: Double = 0.0
    var average: Double = 0.0
    var volume: Double = 0.0
    var volumeCurrency: Double = 0.0
    var timestamp: Double = 0.0
    var closeBuyPrice: Double = 0.0
    var isFavourite: Bool = false
    
    func getChanges() -> Double {
        if closeBuyPrice == 0.0 {
            return 0.0
        }
        return (buyPrice - closeBuyPrice)/closeBuyPrice * 100
    }
    
    init(   code: String, buyPrice: Double, sellPrice: Double,
            lastTrade: Double, high: Double,
            low: Double, average: Double,
            volume: Double, volumeCurrency: Double,
            timestamp: Double, closeBuyPrice: Double, isFavourite: Bool
    ) {
        self.code = code
        self.buyPrice = buyPrice
        self.sellPrice = sellPrice
        self.lastTrade = lastTrade
        self.high = lastTrade
        self.low = low
        self.average = average
        self.volume = volume
        self.volumeCurrency = volumeCurrency
        self.timestamp = timestamp
        self.closeBuyPrice = closeBuyPrice
        self.isFavourite = isFavourite
    }
}

extension TickerCurrencyModel: Mappable {
    init?(map: Map) {
        // do nothing
    }
    
    mutating func mapping(map: Map) {
        let transform = StringToDoubleTransform()
        
        buyPrice <- (map["buy_price"], transform)
        sellPrice <- (map["sell_price"], transform)
        lastTrade <- (map["last_trade"], transform)
        high <- (map["high"], transform)
        low <- (map["low"], transform)
        average <- (map["avg"], transform)
        volume <- (map["vol"], transform)
        volumeCurrency <- (map["vol_curr"], transform)
        timestamp <- map["updated"]
        
        if let price = map["close_buy_price"].currentValue as? Double {
            closeBuyPrice = price
        } else {
            closeBuyPrice <- (map["close_buy_price"], transform)
        }
    }
}

