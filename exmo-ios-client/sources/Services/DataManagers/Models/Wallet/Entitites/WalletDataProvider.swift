//
//  WalletDataProvider.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class WalletDataProvider {
    private var currencies: [WalletCurrencyModel] = [
        WalletCurrencyModel(balance: 0.00187, currency: "BTC", countInOrders: 2),
        WalletCurrencyModel(balance: 0.482, currency: "ETH", countInOrders: 3),
        WalletCurrencyModel(balance: 0.0, currency: "USD", countInOrders: 0),
        WalletCurrencyModel(balance: 0.0, currency: "EUR", countInOrders: 0),
        WalletCurrencyModel(balance: 0.0, currency: "UAH", countInOrders: 0)
    ]
    
    
    func getCurrencies() -> [WalletCurrencyModel] {
        return currencies;
    }
    
    func getCurrencyByIndex(index: Int) -> WalletCurrencyModel {
        return currencies[index]
    }
}
