//
//  CHLiteCurrencyFormatter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHLiteCurrencyFormatter {
    fileprivate var currency: CHLiteCurrencyModel
    
    init(currency: CHLiteCurrencyModel) {
        self.currency = currency
    }
    
    var currencyName: String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: currency.name)
    }
    
    var stockName: String {
        return currency.stock.description
    }
    
    var sellPrice: String {
        return Utils.getFormatedPrice(value: currency.sellPrice)
    }
    
    var volume: String {
        return Utils.getFormatedPrice(value: currency.volume)
    }
    
    var stockIcon: UIImage {
        switch currency.stock {
        case .exmo    : return #imageLiteral(resourceName: "ic_crypto_ltc")
        case .btcTrade: return #imageLiteral(resourceName: "ic_crypto_usdt")
        }
    }
    
}
