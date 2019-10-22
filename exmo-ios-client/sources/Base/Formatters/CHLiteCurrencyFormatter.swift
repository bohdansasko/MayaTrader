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
        return currency.stock.asString
    }
    
    var sellPrice: String {
        let formattedPrice = Utils.getFormatedPrice(value: currency.sellPrice, maxFractDigits: 9)
        return addLabels ? "SELL".localized + " " + formattedPrice : formattedPrice
    }
    
    var buyPrice: String {
        let formattedPrice = Utils.getFormatedPrice(value: currency.buyPrice, maxFractDigits: 9)
        return addLabels ? "BUY".localized + " " + formattedPrice : formattedPrice
    }
    
    var volume: String {
        let formattedPrice = Utils.getFormatedPrice(value: currency.volume)
        return addLabels ? "VOLUME".localized + " " + formattedPrice : formattedPrice
    }
    
    var changes: String {
        let formattedChanges = Utils.getFormatedCurrencyPairChanges(changesValue: currency.changes)
        return addLabels ? "CHANGES".localized + " " + formattedChanges : formattedChanges
    }
    
    var changesColor: UIColor {
        let changes = currency.changes
        return changes > 0.0
            ? .greenBlue
            : changes < 0.0 ? .orangePink : .white
    }
    
    var stockIcon: UIImage {
        switch currency.stock {
        case .exmo    : return #imageLiteral(resourceName: "ic_stock_exmo")
        case .btcTrade: return #imageLiteral(resourceName: "ic_stock_btc_trade")
        }
    }
    
}
