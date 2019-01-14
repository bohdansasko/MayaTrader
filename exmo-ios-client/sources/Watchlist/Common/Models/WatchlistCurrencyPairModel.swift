//
//  WatchlistCurrency.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class WatchlistObject: Object {
    let pairs = List<WatchlistCurrencyObject>()
}

class WatchlistCurrencyObject: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var pairName: String = ""
    @objc dynamic var buyPrice: Double = 0.0
    @objc dynamic var sellPrice: Double = 0.0
    @objc dynamic var timestamp: Double = 0.0
    @objc dynamic var lastTrade: Double = 0.0
    @objc dynamic var volume: Double = 0.0
    @objc dynamic var volumeCurrency: Double = 0.0
    @objc dynamic var closeBuyPrice: Double = 0.0
    @objc dynamic var isFavourite = false
    private var changes: Double = 0.0
    
    init(index: Int, currencyCode: String, tickerCurrencyModel: TickerCurrencyModel) {
        super.init()
        self.index = index
        self.pairName = currencyCode
        buyPrice = tickerCurrencyModel.buyPrice
        sellPrice = tickerCurrencyModel.sellPrice
        timestamp = tickerCurrencyModel.timestamp
        lastTrade = tickerCurrencyModel.lastTrade
        volume = tickerCurrencyModel.volume
        volumeCurrency = tickerCurrencyModel.volumeCurrency
        isFavourite = tickerCurrencyModel.isFavourite
        closeBuyPrice = tickerCurrencyModel.closeBuyPrice
        changes = tickerCurrencyModel.getChanges()
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
    
    override static func primaryKey() -> String? {
        return "pairName"
    }
}

struct WatchlistCurrency {
    var index: Int
    var tickerPair: TickerCurrencyModel
    
    init(index: Int, currencyCode: String, tickerCurrencyModel: TickerCurrencyModel) {
        self.index = index
        self.tickerPair = tickerCurrencyModel
    }
}

extension WatchlistCurrency {
    func getDisplayCurrencyPairName() -> String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: tickerPair.code)
    }
    
    func getBuyAsStr() -> String {
        return Utils.getFormatedPrice(value: tickerPair.buyPrice, maxFractDigits: 10)
    }
    
    func getSellAsStr() -> String {
        return Utils.getFormatedPrice(value: tickerPair.sellPrice, maxFractDigits: 10)
    }
    
    func getIconImageName() -> String {
        let pairComponents = tickerPair.code.components(separatedBy: "_")
        if pairComponents.isEmpty {
            return tickerPair.code.lowercased()
        }
        
        let currencyShortName = pairComponents[0].lowercased()
        let iconName = "ic_crypto_" + currencyShortName
        return iconName
    }
}

extension WatchlistCurrency: Persistable {
    init(managedObject: WatchlistCurrencyObject) {
        self.index = managedObject.index
        self.tickerPair = TickerCurrencyModel(code: managedObject.pairName, buyPrice: managedObject.buyPrice,
                                              sellPrice: managedObject.sellPrice, lastTrade: managedObject.lastTrade,
                                              high: 0, low: 0,
                                              average: 0, volume: managedObject.volume,
                                              volumeCurrency: managedObject.volumeCurrency, timestamp: managedObject.timestamp,
                                              closeBuyPrice: managedObject.closeBuyPrice, isFavourite: managedObject.isFavourite)
    }
    
    func managedObject() -> WatchlistCurrencyObject {
        return WatchlistCurrencyObject(index: index, currencyCode: tickerPair.code, tickerCurrencyModel: tickerPair)
    }
}
