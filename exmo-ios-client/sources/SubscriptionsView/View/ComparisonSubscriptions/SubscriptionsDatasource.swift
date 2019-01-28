//
//  SubscriptionsDatasource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/27/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

class SubscriptionsDatasource: TableDatasource {
    var items: [Any]
    
    init(items: [Any]) {
        self.items = items
        super.init()
    }
    
    override func cellClass(_ indexPath: IndexPath) -> ExmoCollectionCell.Type? {
        return cellClasses()[indexPath.section]
    }
    
    override func cellClasses() -> [ExmoCollectionCell.Type] {
        return [SubscriptionsCell.self]
    }
    
    override func headerClass(_ indexPath: IndexPath) -> ExmoCollectionCell.Type? {
        let classes = headerClasses()
        return indexPath.section < classes.count ? classes[indexPath.section] : nil
    }
    
    override func headerClasses() -> [ExmoCollectionCell.Type] {
        return [SubscriptionsHeaderCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return items.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return indexPath.item < items.count ? items[indexPath.item] : nil
    }
}
