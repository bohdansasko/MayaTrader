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
    var countInOrders: Int
    
    init(balance: Double, currency: String, countInOrders: Int) {
        self.balance = balance
        self.currency = currency
        self.countInOrders = countInOrders
    }
}
