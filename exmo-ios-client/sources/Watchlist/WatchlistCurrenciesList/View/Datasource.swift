//
//  Datasource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/16/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import LBTAComponents

class CurrenciesListDatasource: Datasource {
    var allCurrencies: [WatchlistCurrencyModel] = {
        return [
            WatchlistCurrencyModel(pairName: "LTC_USD", buyPrice: 3.82002126, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 3.72920000, volume: 344.89666572, volumeCurrency: 1320.80049895),
            WatchlistCurrencyModel(pairName: "BTC_USD", buyPrice: 6750.00000001, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 6471.92791793, volume: 1777.63971268, volumeCurrency: 11999068.06062675),
            WatchlistCurrencyModel(pairName: "WAVES_USD", buyPrice: 0.46100233, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 0.41792313, volume: 4068944.53664728, volumeCurrency: 1876597.22030172),
            WatchlistCurrencyModel(pairName: "ETH_USD", buyPrice: 215.00300001, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 200.73272851, volume: 9640.59258642, volumeCurrency: 2072756.32795616)
        ]
    }()
    
    var filteredCurrencies: [WatchlistCurrencyModel] = []
    private var isInSearchingMode = false
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [CurrenciesListCell.self]
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return allCurrencies.count
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [CurrenciesListHeaderCell.self]
    }
    
    override func headerItem(_ section: Int) -> Any? {
        return isInSearchingMode ? "FOUNDED PAIRS" : "ALL PAIRS"
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return allCurrencies[indexPath.item]
    }
    
    func filterBy(text: String) {
        let isWasInSearchingMode = isInSearchingMode
        let textInUpperCase = text.uppercased()
        
        isInSearchingMode = text.count > 0
        
        if !isWasInSearchingMode {
            filteredCurrencies = allCurrencies
        }
        
        if isInSearchingMode {
            allCurrencies = filteredCurrencies.filter({ $0.pairName.contains(textInUpperCase) })
        } else {
            allCurrencies = filteredCurrencies
            filteredCurrencies = []
        }
    }
}
