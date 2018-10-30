//
//  WatchlistCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class WatchlistCurrencyModel: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var pairName: String = ""
    @objc dynamic var buyPrice: Double = 0.0
    @objc dynamic var timeUpdataInSecFrom1970: Double = 0.0
    @objc dynamic var closeBuyPrice: Double = 0.0
    @objc dynamic var volume: Double = 0.0
    @objc dynamic var volumeCurrency: Double = 0.0
    
    init(index: Int, currencyCode: String, tickerCurrencyModel: TickerCurrencyModel) {
        super.init()
        
        self.index = index
        self.pairName = currencyCode
        self.buyPrice = tickerCurrencyModel.buyPrice
        timeUpdataInSecFrom1970 = tickerCurrencyModel.timestamp
        closeBuyPrice = tickerCurrencyModel.closeBuyPrice
        volume = tickerCurrencyModel.volume
        volumeCurrency = tickerCurrencyModel.volumeCurrency
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    func getDisplayCurrencyPairName() -> String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: self.pairName)
    }
    
    func getPriceAsStr() -> String {
        return "$ " + String(buyPrice)
    }
    
    func getChanges() -> Double {
        return Utils.getPairChangesInPercentage(currentValue: buyPrice, prevValue: closeBuyPrice)
    }

    func getIconImageName() -> String {
        let pairComponents = self.pairName.components(separatedBy: "_")
        if pairComponents.isEmpty {
            return pairName.lowercased()
        }

        let currencyShortName = pairComponents[0].lowercased()
        let iconName = "ic_crypto_" + currencyShortName
        return iconName
    }
}
