//
//  WatchlistFavouriteDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIImage
import LBTAComponents

class WatchlistFavouriteDataSource: Datasource {
    var items: [WatchlistCurrencyModel]
    
    init(items: [WatchlistCurrencyModel]) {
        self.items = items
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [WatchlistCardCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return items.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return items[indexPath.item]
    }
}

extension WatchlistFavouriteDataSource {
    func removeItemBy(index: Int) {
        if self.isValidIndex(index: index) {
            items.remove(at: index)
        }
    }
    
    func getCurrencyPairBy(index: Int) -> WatchlistCurrencyModel {
        return items[index]
    }
    
    func isDataExists() -> Bool {
        return items.isEmpty == false
    }
    
    private func isValidIndex(index: Int) -> Bool {
        return index > -1 && index < items.count
    }
}
