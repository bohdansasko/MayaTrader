//
//  Datasource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/16/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import LBTAComponents

struct WatchlistCurrenciesListGroup {
    let name: String
}

class CurrenciesListDatasource: Datasource {
    var allCurrencies: [WatchlistCurrenciesListGroup] = {
        return [
            WatchlistCurrenciesListGroup(name: "BTC"),
            WatchlistCurrenciesListGroup(name: "ETH"),
            WatchlistCurrenciesListGroup(name: "XRP"),
            WatchlistCurrenciesListGroup(name: "LTC"),
            WatchlistCurrenciesListGroup(name: "USD"),
            WatchlistCurrenciesListGroup(name: "EUR"),
            WatchlistCurrenciesListGroup(name: "RUB"),
            WatchlistCurrenciesListGroup(name: "Altcoins"),
            WatchlistCurrenciesListGroup(name: "Fiat")
        ]
    }()
    
    var filteredCurrencies: [WatchlistCurrenciesListGroup] = []
    private var isInSearchingMode = false
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [CurrenciesGroupListCell.self]
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return allCurrencies.count
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [CurrenciesGroupListHeaderCell.self]
    }
    
    override func headerItem(_ section: Int) -> Any? {
        return isInSearchingMode ? "FOUNDED GROUPS" : "ALL GROUPS"
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
            allCurrencies = filteredCurrencies.filter({ $0.name.contains(textInUpperCase) })
        } else {
            allCurrencies = filteredCurrencies
            filteredCurrencies = []
        }
    }
}
