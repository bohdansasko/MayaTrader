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
    private var allBalances: [WalletCurrencyModel]!
    private var usedBalances: [WalletCurrencyModel]!
    private var unusedBalances: [WalletCurrencyModel]!
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
        self.allBalances = getTestData()
        self.usedBalances = getTestData()
        self.unusedBalances = []
    }

    init(walletEntity: WalletEntity) {
        self.init()
        if let container = walletEntity.currencies {
            for currency in container {
                if let entity = currency as? WalletCurrencyEntity {
                    self.allBalances.append(WalletCurrencyModel(currencyEntity: entity))
                }
            }
        }
        filterCurrenciesByFavourites()
        
        if let container = walletEntity.transactionHistory {
            for transaction in container {
                if let entity = transaction as? WalletTransactionHistoryEntity {
                    transactionHistory.append(WalletTransactionHistory(transaction: entity))
                }
            }
        }
    }

    func isDataExists() -> Bool {
        return allBalances.isEmpty == false
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
        
        self.allBalances.removeAll()
        var id = 0
        for (key, value) in rawBalances {
            let dValue = Double(value)!
            let countInOrders = Int32(rawReserved[key]!)!
            self.allBalances.append(WalletCurrencyModel(orderId: id, balance: dValue, currency: key, countInOrders: countInOrders))
            id += 1
        }
        rawBalances.removeAll()
        rawReserved.removeAll()
        
        filterCurrenciesByFavourites()
    }

    func getWalletEntity(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) -> WalletEntity {
        let walletEntity = WalletEntity(entity: entity, insertInto: context)
        var currencies = NSSet()
        for currency in self.allBalances {
            let c = WalletCurrencyEntity(context: context!)
            c.balance = currency.balance
            c.inOrders = currency.countInOrders
            c.currency = currency.currency
            c.isFavourite = currency.isFavourite
            c.wallet = walletEntity
            c.indexInTableView = Int32(currency.orderId)

            currencies = currencies.adding(c) as NSSet
        }
        walletEntity.addToCurrencies(currencies)
        return walletEntity
    }
    
    private func getTestData() -> [WalletCurrencyModel] {
        return [
            WalletCurrencyModel(orderId: 0, balance: 0, currency: "UAH", countInOrders: 0),
            WalletCurrencyModel(orderId: 1, balance: 0.8961234, currency: "BTC", countInOrders: 10),
            WalletCurrencyModel(orderId: 2, balance: 2000.123, currency: "LTC", countInOrders: 5)
        ]
    }
    
    func getCurrenciesByFilter(filterClosure: (WalletCurrencyModel) -> Bool) -> [WalletCurrencyModel] {
        return allBalances.filter(filterClosure)
    }
    
    func getCountUsedCurrencies() -> Int {
        return self.usedBalances.count;
    }

    func getCountUnusedCurrencies() -> Int {
        return self.unusedBalances.count;
    }

    func getCountSections() -> Int {
        return unusedBalances.count > 0 ? 2 : 1
    }
    
    func getCountAllExistsCurrencies() -> Int {
        return self.allBalances.count;
    }
    
    func getFavouriteCurrencies() -> [WalletCurrencyModel] {
        return self.usedBalances;
    }

    func getUnusedCurrencies() -> [WalletCurrencyModel] {
        return self.unusedBalances;
    }

    func getAllExistsCurrencies() -> [WalletCurrencyModel] {
        return self.allBalances;
    }

    private func getUsedCurrencyByIndex(index: Int) -> WalletCurrencyModel {
        return index > -1 && index < self.usedBalances.count ? self.usedBalances[index] : WalletCurrencyModel()
    }

    private func getUnusedCurrencyByIndex(index: Int) -> WalletCurrencyModel {
        return index > -1 && index < self.unusedBalances.count ? self.unusedBalances[index] : WalletCurrencyModel()
    }

    private func getGeneralCurrencyByIndex(index: Int) -> WalletCurrencyModel {
        return index > -1 && index < self.allBalances.count ? self.allBalances[index] : WalletCurrencyModel()
    }
    
    func getCurrencyByIndexPath(indexPath: IndexPath, numberOfSections: Int) -> WalletCurrencyModel {
        if (numberOfSections > 0) {
            switch indexPath.section {
            case 0:  return getUsedCurrencyByIndex(index: indexPath.row)
            case 1:  return getUnusedCurrencyByIndex(index: indexPath.row)
            default: return WalletCurrencyModel()
            }
        } else {
            return getGeneralCurrencyByIndex(index: indexPath.row)
        }
    }

    mutating func setIsFavourite(id: Int, isFavourite: Bool) {
        if id > -1 && id < self.allBalances.count {
            self.allBalances[id].isFavourite = isFavourite
            filterCurrenciesByFavourites()
            print("balances[\(id)] has favourite state: \(isFavourite)")
        }
    }
    
    mutating func filterCurrenciesByFavourites() {
        self.usedBalances   = self.allBalances.filter({ return $0.isFavourite })
        self.usedBalances.sort(by: { $0.orderId < $1.orderId })
        self.unusedBalances = self.allBalances.filter({ return !($0.isFavourite) })
    }
    
    
    mutating func swapUsedCurrencies(from sourceRow: Int, to destinationRow: Int) {
        if (sourceRow != destinationRow) {
            swap(&self.usedBalances[sourceRow].orderId, &self.usedBalances[destinationRow].orderId)
            self.usedBalances.swapAt(sourceRow, destinationRow)
        }
    }
    
    func getAmountMoneyInBTC() -> Double {
        var sum = 0.0
        for currency in allBalances {
            sum += currency.balance
        }
        
        return sum
    }
    
    func getAmountMoneyInUSD() -> Double {
        var sum = 0.0
        for currency in allBalances {
            sum += currency.balance
        }
        
        return sum
    }

    func merge(_ walletFromCache : WalletModel) {
        let balancesFromCache = walletFromCache.getUnusedCurrencies()
        balancesFromCache.forEach({ currencyModel in
            if let currency = self.allBalances.first(where: { $0.currency == currencyModel.currency }) {
                currency.isFavourite = currencyModel.isFavourite
            }
        })
    }
}
