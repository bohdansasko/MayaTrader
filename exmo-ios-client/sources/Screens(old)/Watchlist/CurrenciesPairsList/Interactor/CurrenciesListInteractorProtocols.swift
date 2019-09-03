//
// Created by Bogdan Sasko on 1/1/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol CurrenciesListInteractorInput: class {
    func viewIsReady()
    func viewWillDisappear()
    func setCurrencyGroupName(_ currencyGroupName: String)
    func cacheFavCurrencyPair(datasourceItem: Any?, isSelected: Bool)
}


protocol CurrenciesListInteractorOutput: class {
    func updateFavPairs(items: [WatchlistCurrency])
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency])
    
    func onMaxAlertsSelectedError(msg: String)
}