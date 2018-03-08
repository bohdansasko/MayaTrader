//
//  WalletDataProvider.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper

struct WalletModel : Mappable {
    var balances: [WalletCurrencyModel]!
    
    private var rawBalances: [String: String] {
        didSet { tryUpdateData() }
    }

    private var rawReserved: [String: String] {
        didSet { tryUpdateData() }
    }
    
    init?(map: Map) {
        self.init()
        if map.JSON["balances"] == nil {
            return nil
        }
    }
    
    init() {
        self.rawBalances = [:]
        self.rawReserved = [:]
        self.balances = []
    }

    func isDataExists() -> Bool {
        return !balances.isEmpty
    }

    mutating func mapping(map: Map) {
        rawBalances <- map["balances"]
        rawReserved <- map["reserved"]
    }
    
    private mutating func tryUpdateData() {
        let shouldBreakFromMethod = rawBalances.isEmpty || rawReserved.isEmpty;
        if shouldBreakFromMethod {
             return
        }
        
        self.balances.removeAll()
        for (key, value) in rawBalances {
            let dValue = Double(value)!
            let countInOrders = Int(rawReserved[key]!)!
            balances.append(WalletCurrencyModel(balance: dValue, currency: key, countInOrders: countInOrders))
        }
        rawBalances.removeAll()
        rawReserved.removeAll()
    }
    
    private func getTestData() -> [WalletCurrencyModel] {
        return [
            WalletCurrencyModel(balance: 0, currency: "UAH", countInOrders: 0)
        ]
    }
    
    func getCountCurrencies() -> Int {
        return balances.count;
    }
    
    func getCurrencyByIndex(index: Int) -> WalletCurrencyModel {
        return index > -1 && index < balances.count ? balances[index] : WalletCurrencyModel()
    }
}
