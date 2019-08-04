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
    
    func getCurrencies(by stockExchange: CHStockExchange, selectedCurrencies: [String] = [], isExtended: Bool = true) -> Single<[String]> {
        let params: [String: Any] = [
            "stock_exchange"     : stockExchange.rawValue,
            "selected_currencies": selectedCurrencies,
            "extended"           : isExtended
        ]
        return self.base.sendRequest(messageType: .getSelectedCurrencies, params: params)
            .mapInBackground { json -> [String] in
                return []
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
    func getCurrencies(like likeString: String, stocks: [CHStockExchange], isExtended: Bool = true) -> Observable<[CHLiteCurrencyModel]> {
        let params: [String: Any] = [
            "like_string"     : likeString,
            "stock_exchanges" : stocks.map { $0.rawValue },
            "extended"        : isExtended
        ]
        return self.base.sendRequest(messageType: .getCurrenciesLikeString, params: params)
            .mapInBackground { json -> [CHLiteCurrencyModel] in
                var currencies = [CHLiteCurrencyModel]()
                for jsonCurrencyDetails in json["stock_exchanges"]["exmo"]["currencies"].arrayValue {
                    guard
                        let jsonRawString = jsonCurrencyDetails.rawString(),
                        let currency = Mapper<CHLiteCurrencyModel>().map(JSONString: jsonRawString) else {
                        continue
                    }
                    currencies.append(currency)
                }
                return currencies
            }
    }
}
