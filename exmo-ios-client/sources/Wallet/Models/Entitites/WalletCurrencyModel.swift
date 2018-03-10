//
//  WalletCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class WalletCurrencyModel {
    var balance: Double
    var currency: String
    var countInOrders: Int32
    var isFavourite = true

    init(currencyEntity: WalletCurrencyEntity?) {
        self.balance = currencyEntity?.balance ?? 0.0
        self.currency = currencyEntity?.currency ?? ""
        self.countInOrders = currencyEntity?.inOrders ?? 0
        self.isFavourite = currencyEntity?.isFavourite ?? false
    }

    init(balance: Double = 0.0, currency: String = "", countInOrders: Int32 = 0) {
        self.balance = balance
        self.currency = currency
        self.countInOrders = countInOrders
    }
}
