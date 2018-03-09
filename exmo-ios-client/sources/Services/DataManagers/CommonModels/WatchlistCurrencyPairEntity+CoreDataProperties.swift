//
//  WatchlistCurrencyPairEntity+CoreDataProperties.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//
//

import Foundation
import CoreData


extension WatchlistCurrencyPairEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WatchlistCurrencyPairEntity> {
        return NSFetchRequest<WatchlistCurrencyPairEntity>(entityName: "WatchlistCurrencyPairEntity")
    }

    @NSManaged public var pairName: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var user: UserEntity?

}
