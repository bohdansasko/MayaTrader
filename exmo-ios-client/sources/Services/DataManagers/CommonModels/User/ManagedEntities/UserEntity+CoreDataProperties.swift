//
//  UserEntity+CoreDataProperties.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var exmoIdentifier: String?
    @NSManaged public var key: String?
    @NSManaged public var secret: String?
    @NSManaged public var uid: Int32
    @NSManaged public var watchlistCurrencyPairs: NSSet?
    @NSManaged public var wallet: WalletEntity?

}

// MARK: Generated accessors for watchlistCurrencyPairs
extension UserEntity {

    @objc(addWatchlistCurrencyPairsObject:)
    @NSManaged public func addToWatchlistCurrencyPairs(_ value: WatchlistCurrencyPairEntity)

    @objc(removeWatchlistCurrencyPairsObject:)
    @NSManaged public func removeFromWatchlistCurrencyPairs(_ value: WatchlistCurrencyPairEntity)

    @objc(addWatchlistCurrencyPairs:)
    @NSManaged public func addToWatchlistCurrencyPairs(_ values: NSSet)

    @objc(removeWatchlistCurrencyPairs:)
    @NSManaged public func removeFromWatchlistCurrencyPairs(_ values: NSSet)

}
