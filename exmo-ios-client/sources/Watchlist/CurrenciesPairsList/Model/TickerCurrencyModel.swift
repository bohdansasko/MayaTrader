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
    private(set) var buyPrice: Double = 0.0
    private(set) var sellPrice: Double = 0.0
    private(set) var lastTrade: Double = 0.0
    private(set) var high: Double = 0.0
    private(set) var low: Double = 0.0
    private(set) var average: Double = 0.0
    private(set) var volume: Double = 0.0
    private(set) var volumeCurrency: Double = 0.0
    private(set) var timestamp: Double = 0.0
    private(set) var closeBuyPrice: Double = 0.0
    var isFavourite: Bool = false
    
    func getChanges() -> Double {
        if closeBuyPrice == 0.0 {
            return 0.0
        }
        return (buyPrice - closeBuyPrice)/closeBuyPrice * 100
    }
}

extension TickerCurrencyModel: Mappable {
    init?(map: Map) {
        // do nothing
    }
    
    mutating func mapping(map: Map) {
        let transform = TransformOf<Double, String>(
            fromJSON: { $0 == nil ? nil : Double($0!) },
            toJSON: { $0 == nil ? nil : String($0!) }
        )
        
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

