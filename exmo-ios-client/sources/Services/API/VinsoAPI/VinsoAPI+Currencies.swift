//
//  VinsoAPI+Currencies.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift

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
    
}
