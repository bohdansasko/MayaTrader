//
//  CurrenciesListModuleConfigurator.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class CurrenciesListModuleConfigurator {
    var viewController: CurrenciesListViewController!
    init() {
        configure()
    }
    
    private func configure() {
        viewController = CurrenciesListViewController()
        viewController.datasource = CurrenciesListDataSource(items: getTestData())
    }
    
    fileprivate func getTestData() -> [WatchlistCurrencyModel] {
        return [
            WatchlistCurrencyModel(index: 0, pairName: "ETH_LTC", buyPrice: 3.82002126, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 3.72920000, volume: 344.89666572, volumeCurrency: 1320.80049895),
            WatchlistCurrencyModel(index: 1, pairName: "ETH_USD", buyPrice: 6750.00000001, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 6471.92791793, volume: 1777.63971268, volumeCurrency: 11999068.06062675),
            WatchlistCurrencyModel(index: 2, pairName: "ETH_BTC", buyPrice: 0.46100233, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 0.41792313, volume: 4068944.53664728, volumeCurrency: 1876597.22030172)
        ]
    }
}
