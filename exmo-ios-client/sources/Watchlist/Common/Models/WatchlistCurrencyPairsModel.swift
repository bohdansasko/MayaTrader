//
//  WatchlistCurrencyPairsModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIImage

class WatchlistCurrencyPairModel {
    private var pairName: String
    private var currencyVolumeStr: String
    private var price: Double
    private var priceIndicator: Double
    
    init(pairName: String, currencyVolumeStr: String, price: Double, priceIndicator: Double) {
        self.pairName = pairName
        self.currencyVolumeStr = currencyVolumeStr
        self.price = price
        self.priceIndicator = priceIndicator
    }
    
    func getPairName() -> String {
        return self.pairName
    }
    
    func getVolumeStr() -> String {
        return self.currencyVolumeStr
    }
    
    func getPriceAsStr() -> String {
        return "$ " + String(price)
    }
    
    func getPriceIndicatorAsStr() -> String {
        return getSign() + String(abs(priceIndicator)) + "%"
    }
    
    private func getSign() -> String {
        return priceIndicator > 0.0
            ? "+"
            : priceIndicator < 0.0
                ? "-"
                : ""
    }
    
    static func mock() -> WatchlistCurrencyPairModel {
        return WatchlistCurrencyPairModel(pairName: "Test/Test", currencyVolumeStr: "T", price: 0.0, priceIndicator: 0.0)
    }
    
    func getPriceIndicator() -> Double {
        return self.priceIndicator
    }
    
    func getIconImage() -> UIImage {
        let suffix = pairName.components(separatedBy: "/")[0].lowercased()
        let iconName = "icon_" + suffix
        return UIImage(named: iconName)!
    }
}

class WatchlistCurrencyPairsModel {
    var data: [WatchlistCurrencyPairModel]
    
    init() {
        data = [
            WatchlistCurrencyPairModel(pairName: "ETH/USD", currencyVolumeStr: "$ 269387", price: 230.04, priceIndicator: 0.79),
            WatchlistCurrencyPairModel(pairName: "BTC/USD", currencyVolumeStr: "$ 8589420", price: 4970.34, priceIndicator: -2.48),
            WatchlistCurrencyPairModel(pairName: "BTC/USD", currencyVolumeStr: "$ 8589420", price: 4970.34, priceIndicator: -2.48),
            WatchlistCurrencyPairModel(pairName: "ETH/USD", currencyVolumeStr: "$ 1060706", price: 0.18105, priceIndicator: 1.19)
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
