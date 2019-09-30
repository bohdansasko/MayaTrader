//
//  VinsoAPI+Currencies.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift
import ObjectMapper

extension Reactive where Base: VinsoAPI {
    typealias StockName      = String
    typealias CurrencyName   = String
    typealias CurrenciesList = [CurrencyName]

    func getCurrencyCandles(name: CurrencyName, stock: CHStockExchange, period: CHPeriod, limit: Int, offset: Int) -> Single<[CHCandleModel]> {
        let params: [String: Any] = [
            "currency"     : name,
            "stock"        : stock.description,
            "period"       : period.asArg,
            "limit"        : limit,
            "offset"       : offset
        ]
        
        return self.base.sendRequest(messageType: .getCurrencyCandles, params: params)
            .mapInBackground { json -> [CHCandleModel] in
                guard let jsonCurrenciesList = json["candles"].array else {
                    throw CHVinsoAPIError.missingRequiredParams
                }
                
                var candles = [CHCandleModel]()
                for jsonCurrencyDetails in jsonCurrenciesList {
                    guard
                        let jsonRawString = jsonCurrencyDetails.rawString(),
                        let currency = Mapper<CHCandleModel>().map(JSONString: jsonRawString) else {
                        continue
                    }
                    candles.append(currency)
                }
                return candles
            }
            .asSingle()
    }
    
    func getCurrency(stock: StockName, name: CurrencyName, isExtended: Bool = true) -> Single<CHLiteCurrencyModel> {
        return getCurrencies(selectedCurrencies: [stock: [name]], isExtended: isExtended).map{ $0.first! }
    }
    
    func getCurrencies(selectedCurrencies: [StockName: CurrenciesList], isExtended: Bool = true) -> Single<[CHLiteCurrencyModel]> {
        assert(!selectedCurrencies.isEmpty, "at least must be one element")
        
        let params: [String: Any] = [
            "selected_currencies": selectedCurrencies,
            "extended"           : isExtended
        ]

        return self.base.sendRequest(messageType: .getSelectedCurrencies, params: params)
            .mapInBackground { json -> [CHLiteCurrencyModel] in
                guard let stocksJson = json["currencies"].dictionary else {
                    throw CHVinsoAPIError.missingRequiredParams
                }
                
                var currencies = [CHLiteCurrencyModel]()
                
                for (stockName, stockJsonCurrencies)  in stocksJson {
                    guard let currenciesListJson = stockJsonCurrencies.array else {
                        continue
                    }
                    for currencyJson in currenciesListJson {
                        guard var jsonDict = currencyJson.dictionaryObject else {
                            continue
                        }
                        jsonDict["stock_exchange"] = stockName
                        
                        if let currency = Mapper<CHLiteCurrencyModel>().map(JSON: jsonDict) {
                            currencies.append(currency)
                        }
                    }
                }
                
                return currencies
            }
            .asSingle()
    }
    
    /// extended - how many fields will be retured
    func getCurrencyGroup(by stockExchange: CHStockExchange, isExtended: Bool = true) -> Single<[String]> {
        let params: [String: Any] = [
            "currency_group"     : "",
            "stock_exchange"     : stockExchange.rawValue,
            "extended"           : isExtended
        ]
        return self.base.sendRequest(messageType: .getCurrencyGroup, params: params)
            .mapInBackground { json -> [String] in
                return []
            }
            .asSingle()
    }
    
    /// return currencies which like likeString
    func getCurrencies(like likeString: String, sortBy: CHExchangeSortBy, order: CHSortOrder, limit: Int, offset: Int, isExtended: Bool = false) -> Single<[CHLiteCurrencyModel]> {
        let params: [String: Any] = [
            "like_string": likeString,
            "limit"      : limit,
            "offset"     : offset,
            "sort_by"    : sortBy.apiArg,
            "sort_strategy": order.apiArg,
            "extended"   : isExtended
        ]

        return self.base.sendRequest(messageType: .getCurrenciesLikeString, params: params)
            .mapInBackground { json -> [CHLiteCurrencyModel] in
                guard let jsonCurrenciesList = json["currencies"].array else {
                    throw CHVinsoAPIError.missingRequiredParams
                }
                
                var currencies = [CHLiteCurrencyModel]()
                for jsonCurrencyDetails in jsonCurrenciesList {
                    guard
                        let jsonRawString = jsonCurrencyDetails.rawString(),
                        let currency = Mapper<CHLiteCurrencyModel>().map(JSONString: jsonRawString) else {
                        continue
                    }
                    currencies.append(currency)
                }
                return currencies
            }
            .asSingle()
    }
    
    /**
        - parameter currencies: "BTC", "USD", etc.
        - parameter currenciesMoney: [String - currency name, Double - amount money for that currency]
        - parameter stockExchange: where price will be taken and calculated
        - returns: price in BTC and USD
    */
    func getBalance(in currencies: [String], info currenciesMoney: [String: Double], at stockExchange: CHStockExchange) -> Single<CHWalletBalance?> {
        let params: [String: Any] = [
            "convert_to_currencies": currencies,
            "stock_exchange"       : stockExchange.rawValue,
            "wallet"               : currenciesMoney
        ]

        return self.base.sendRequest(messageType: .getUserBalance, params: params)
            .mapInBackground { json in
                guard let jsonBalance = json["wallet"].dictionaryObject else {
                    throw CHVinsoAPIError.missingRequiredParams
                }
                
                let balance = Mapper<CHWalletBalance>().map(JSON: jsonBalance)
                return balance
            }
            .asSingle()
    }
    
}
