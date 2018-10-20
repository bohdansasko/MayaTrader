//
//  WatchlistCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

struct WatchlistCurrencyModel {
    let index: Int
    let pairName: String
    let buyPrice: Double
    let timeUpdataInSecFrom1970: Double
    let closeBuyPrice: Double
    let volume: Double
    let volumeCurrency: Double
    
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
