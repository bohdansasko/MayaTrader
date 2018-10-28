//
//  CurrenciesListDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

class CurrenciesListDataSource: Datasource {
    var items: [WatchlistCurrencyModel]
    var tempItems: [WatchlistCurrencyModel] = []
    private var isInSearchingMode = false
    
    init(items: [WatchlistCurrencyModel]) {
        self.items = items
        super.init()
        
        self.updateItemsIndexis()
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [CurrenciesListCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return items.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return items[indexPath.item]
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [CurrenciesListHeaderCell.self]
    }
    
    func filterBy(text: String) {
        let isWasInSearchingMode = isInSearchingMode
        let textInUpperCase = text.uppercased()
        
        isInSearchingMode = text.count > 0
        
        if !isWasInSearchingMode {
            tempItems = items
        }
        
        if isInSearchingMode {
            items = tempItems.filter({ $0.pairName.contains(textInUpperCase) })
            updateItemsIndexis()
        } else {
            items = tempItems
            tempItems = []
        }
    }
    
    private func updateItemsIndexis() {
        for itemIndex in 0..<items.count {
            items[itemIndex].index = itemIndex
        }
    }
}
