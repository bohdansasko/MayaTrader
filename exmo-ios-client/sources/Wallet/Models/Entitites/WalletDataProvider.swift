//
//  WalletDataProvider.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

class WalletTransactionHistory {
    var amount: Double
    var date: Date?
    var orderId: Int64
    var pair: String
    var price: Double
    var quantity: Double
    var tradeId: Int32
    var type: String

    init(transaction: WalletTransactionHistoryEntity) {
        self.amount = transaction.amount
        self.date = transaction.date as Date?
        self.orderId = transaction.orderId
        self.pair = transaction.pair!
        self.price = transaction.price
        self.quantity = transaction.quantity
        self.tradeId = transaction.tradeId
        self.type = transaction.type!
    }
}

struct WalletModel : Mappable {
    private var balances: [WalletCurrencyModel]!
    private var transactionHistory: [WalletTransactionHistory]!

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

    init(walletEntity: WalletEntity) {
        self.init()
        if let container = walletEntity.currencies {
            for currency in container {
                if let entity = currency as? WalletCurrencyEntity {
                    balances.append(WalletCurrencyModel(currencyEntity: entity))
                }
            }
        }

        if let container = walletEntity.transactionHistory {
            for transaction in container {
                if let entity = transaction as? WalletTransactionHistoryEntity {
                    transactionHistory.append(WalletTransactionHistory(transaction: entity))
                }
            }
        }
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
            let countInOrders = Int32(rawReserved[key]!)!
            balances.append(WalletCurrencyModel(balance: dValue, currency: key, countInOrders: countInOrders))
        }
        rawBalances.removeAll()
        rawReserved.removeAll()
    }

    func getWalletEntity(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) -> WalletEntity {
        let walletEntity = WalletEntity(entity: entity, insertInto: context)
        let currencies = NSSet()
        for currency in balances {
            let c = WalletCurrencyEntity(context: context!)
            c.balance = currency.balance
            c.inOrders = currency.countInOrders
            c.currency = currency.currency
            c.isFavourite = currency.isFavourite
            c.wallet = walletEntity

            currencies.adding(c)
        }
        walletEntity.addToCurrencies(currencies)
        return walletEntity
    }
    
    private func getTestData() -> [WalletCurrencyModel] {
        return [
            WalletCurrencyModel(balance: 0, currency: "UAH", countInOrders: 0)
        ]
    }
    
    func getCountCurrencies() -> Int {
        return balances.count;
    }

    func getCurrencies() -> [WalletCurrencyModel] {
        return balances;
    }

    func getCurrencyByIndex(index: Int) -> WalletCurrencyModel {
        return index > -1 && index < balances.count ? balances[index] : WalletCurrencyModel()
    }
}
