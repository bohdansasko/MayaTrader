//
//  CurrenciesListDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents


class TableDatasource {
    func cellClass(_ indexPath: IndexPath) -> ExmoCollectionCell.Type? {
        return nil
    }
    
    func headerClass(_ indexPath: IndexPath) -> ExmoCollectionCell.Type? {
        return nil
    }

    func cellClasses() -> [ExmoCollectionCell.Type] {
        return []
    }
    
    func numberOfItems(_ section: Int) -> Int {
        return 0
    }
    
    func headerItem(_ section: Int) -> Any? {
        return nil
    }
    
    func item(_ indexPath: IndexPath) -> Any? {
        return nil
    }
    
    func headerClasses() -> [ExmoCollectionCell.Type] {
        return []
    }
}

class CurrenciesListDataSource: TableDatasource {
    var items: [WatchlistCurrency]
    var tempItems: [WatchlistCurrency] = []
    private var isInSearchingMode = false
    
    init(items: [WatchlistCurrency]) {
        self.items = items
        super.init()
        
        self.updateItemsIndexis()
    }
    
    override func cellClass(_ indexPath: IndexPath) -> ExmoCollectionCell.Type? {
        return cellClasses()[indexPath.section]
    }
    
    override func headerClass(_ indexPath: IndexPath) -> ExmoCollectionCell.Type? {
        let classes = headerClasses()
        return indexPath.section < classes.count ? classes[indexPath.section] : nil
    }
    
    override func cellClasses() -> [ExmoCollectionCell.Type] {
        return [CurrenciesListCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return items.count
    }

    override func item(_ indexPath: IndexPath) -> Any? {
        return items[indexPath.item]
    }
    
    override func headerClasses() -> [ExmoCollectionCell.Type] {
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
            items = tempItems.filter({ $0.tickerPair.code.contains(textInUpperCase) })
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

class WatchlistCardsDataSource: TableDatasource {
    var items: [WatchlistCurrency]

    init(items: [WatchlistCurrency]) {
        self.items = items
        super.init()
    }

    override func cellClass(_ indexPath: IndexPath) -> ExmoCollectionCell.Type? {
        return cellClasses()[indexPath.section]
    }

    override func cellClasses() -> [ExmoCollectionCell.Type] {
        return [] // [WatchlistCardCell.self]
    }

    override func numberOfItems(_ section: Int) -> Int {
        return items.count
    }

    override func item(_ indexPath: IndexPath) -> Any? {
        return indexPath.item < items.count ? items[indexPath.item] : nil
    }
}
