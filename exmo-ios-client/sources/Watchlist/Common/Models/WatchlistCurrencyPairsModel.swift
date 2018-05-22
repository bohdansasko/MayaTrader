//
//  WatchlistCurrencyPairsModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class WatchlistCurrencyPairModel {
    private var fullName: String
    private var shortName: String
    private var price: Double
    private var priceIndicator: Double
    
    init(fullName: String, shortName: String, price: Double, priceIndicator: Double) {
        self.fullName = fullName
        self.shortName = shortName
        self.price = price
        self.priceIndicator = priceIndicator
    }
    
    func getFullName() -> String {
        return fullName
    }
    func getShortName() -> String {
        return shortName
    }
    func getPriceAsStr() -> String {
        return "$ " + String(price)
    }
    func getPriceIndicatorAsStr() -> String {
        return getSign() + String(priceIndicator) + "%"
    }
    
    private func getSign() -> String {
        return priceIndicator > 0.0
            ? "+"
            : priceIndicator < 0.0
                ? "-"
                : ""
    }
    
    static func mock() -> WatchlistCurrencyPairModel {
        return WatchlistCurrencyPairModel(fullName: "Test/Test", shortName: "T", price: 0.0, priceIndicator: 0.0)
    }
}

class WatchlistCurrencyPairsModel {
    var data: [WatchlistCurrencyPairModel]
    
    init() {
        data = [
            WatchlistCurrencyPairModel(fullName: "ETC/USD", shortName: "269387 USD", price: 230.04, priceIndicator: 0.79),
            WatchlistCurrencyPairModel(fullName: "BTC/USD", shortName: "8589420 USD", price: 4970.34, priceIndicator: -2.48),
            WatchlistCurrencyPairModel(fullName: "XRP/USD", shortName: "1060706 USD", price: 0.18105, priceIndicator: 1.19)
        ]
    }
    
    func getCountOrders() -> Int {
        return data.count
    }

    func getCurrencyPairBy(index: Int) -> WatchlistCurrencyPairModel {
        return index > -1 && index < data.count ? data[index] : WatchlistCurrencyPairModel.mock()
    }

    func isDataExists() -> Bool {
        return data.isEmpty == false
    }
}
