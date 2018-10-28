//
//  CurrenciesGroupsDatasource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/16/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import LBTAComponents

struct CurrenciesGroupsGroup {
    let name: String
}

class CurrenciesListDatasource: Datasource {
    var allCurrencies: [CurrenciesGroupsGroup] = {
        return [
            CurrenciesGroupsGroup(name: "BTC"),
            CurrenciesGroupsGroup(name: "ETH"),
            CurrenciesGroupsGroup(name: "XRP"),
            CurrenciesGroupsGroup(name: "LTC"),
            CurrenciesGroupsGroup(name: "USD"),
            CurrenciesGroupsGroup(name: "EUR"),
            CurrenciesGroupsGroup(name: "RUB"),
            CurrenciesGroupsGroup(name: "Altcoins"),
            CurrenciesGroupsGroup(name: "Fiat")
        ]
    }()
    
    var filteredCurrencies: [CurrenciesGroupsGroup] = []
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
