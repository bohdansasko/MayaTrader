//
//  WatchlistCurrencyPairsModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIImage

class WatchlistCurrencyPairsModel {
    var data: [WatchlistCurrencyPairModel]
    
    init() {
        self.data = []
        self.data = self.getTestData()
    }
    
    private func getTestData() -> [WatchlistCurrencyPairModel] {
        return [
            WatchlistCurrencyPairModel(pairName: "ETH_USD", currencyVolumeStr: "$ 269387", price: 230.04, priceIndicator: 0.79),
            WatchlistCurrencyPairModel(pairName: "BTC_USD", currencyVolumeStr: "$ 8589420", price: 4970.34, priceIndicator: -2.48),
            WatchlistCurrencyPairModel(pairName: "BTC_USD", currencyVolumeStr: "$ 8589420", price: 4970.34, priceIndicator: -2.48),
            WatchlistCurrencyPairModel(pairName: "ETH_USD", currencyVolumeStr: "$ 1060706", price: 0.18105, priceIndicator: 1.19)
        ]
    }
    
    func removeItemBy(index: Int) {
        if self.isValidIndex(index: index) {
            self.data.remove(at: index)
        }
    }
    
    func getCountOrders() -> Int {
        return self.data.count
    }

    func getCurrencyPairBy(index: Int) -> WatchlistCurrencyPairModel {
        return self.isValidIndex(index: index) ? self.data[index] : WatchlistCurrencyPairModel.mock()
    }

    func isDataExists() -> Bool {
        return self.data.isEmpty == false
    }
    
    private func isValidIndex(index: Int) -> Bool {
        return index > -1 && index < data.count
    }
}
