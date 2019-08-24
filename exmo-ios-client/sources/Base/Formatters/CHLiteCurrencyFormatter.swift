//
//  CHLiteCurrencyFormatter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHLiteCurrencyFormatter {
    fileprivate let currency: CHLiteCurrencyModel
    fileprivate let addLabels: Bool
                let isFavourite: Bool

    init(currency: CHLiteCurrencyModel, addLabels: Bool, isFavourite: Bool) {
        self.currency    = currency
        self.addLabels   = addLabels
        self.isFavourite = isFavourite
    }
    
}

// MARK: - Getters

extension CHLiteCurrencyFormatter {
    
    var currencyName: String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: currency.name)
    }
    
    var stockName: String {
        return currency.stock.description
    }
    
    var sellPrice: String {
        let formattedPrice = Utils.getFormatedPrice(value: currency.sellPrice)
        return addLabels ? "SELL".localized + " " + formattedPrice : formattedPrice
    }
    
    var buyPrice: String {
        let formattedPrice = Utils.getFormatedPrice(value: currency.buyPrice)
        return addLabels ? "BUY".localized + " " + formattedPrice : formattedPrice
    }
    
    var volume: String {
        let formattedPrice = Utils.getFormatedPrice(value: currency.volume)
        return addLabels ? "VOLUME".localized + " " + formattedPrice : formattedPrice
    }
    
    var changes: String {
        // cm.tickerPair.getChanges()
        let formattedChanges = Utils.getFormatedCurrencyPairChanges(changesValue: 0.18)
        return addLabels ? "CHANGES".localized + " " + formattedChanges : formattedChanges
    }
    
    var changesColor: UIColor {
        let changes = 0.18
        return changes > 0.0
            ? .greenBlue
            : changes < 0.0 ? .orangePink : .white
    }
    
    var stockIcon: UIImage {
        switch currency.stock {
        case .exmo    : return #imageLiteral(resourceName: "ic_crypto_ltc")
        case .btcTrade: return #imageLiteral(resourceName: "ic_crypto_usdt")
        }
    }
    
}
