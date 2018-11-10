//
//  WalletCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class WalletCurrencyModel: NSObject {
    var orderId: Int
    var balance: Double
    var currency: String
    var countInOrders: Int32
    var isFavourite = true

    init(currencyEntity: WalletCurrencyEntity?) {
        self.orderId = currencyEntity != nil ? Int((currencyEntity?.indexInTableView)!) : 0
        self.balance = currencyEntity?.balance ?? 0.0
        self.currency = currencyEntity?.currency ?? ""
        self.countInOrders = currencyEntity?.inOrders ?? 0
        self.isFavourite = currencyEntity?.isFavourite ?? false
    }

    init(orderId: Int = 0, balance: Double = 0.0, currency: String = "", countInOrders: Int32 = 0) {
        self.orderId = orderId
        self.balance = balance
        self.currency = currency
        self.countInOrders = countInOrders
    }
}

extension WalletCurrencyModel: NSItemProviderWriting {
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return [] // something here
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Swift.Void) -> Progress? {
        return nil // something here
    }
}
