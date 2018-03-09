//
//  WalletEntity+CoreDataProperties.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//
//

import Foundation
import CoreData


extension WalletEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletEntity> {
        return NSFetchRequest<WalletEntity>(entityName: "WalletEntity")
    }

    @NSManaged public var currencies: NSSet?
    @NSManaged public var transactionHistory: NSSet?
    @NSManaged public var user: UserEntity?

}

// MARK: Generated accessors for currencies
extension WalletEntity {

    @objc(addCurrenciesObject:)
    @NSManaged public func addToCurrencies(_ value: WalletCurrencyEntity)

    @objc(removeCurrenciesObject:)
    @NSManaged public func removeFromCurrencies(_ value: WalletCurrencyEntity)

    @objc(addCurrencies:)
    @NSManaged public func addToCurrencies(_ values: NSSet)

    @objc(removeCurrencies:)
    @NSManaged public func removeFromCurrencies(_ values: NSSet)

}

// MARK: Generated accessors for transactionHistory
extension WalletEntity {

    @objc(addTransactionHistoryObject:)
    @NSManaged public func addToTransactionHistory(_ value: WalletTransactionHistoryEntity)

    @objc(removeTransactionHistoryObject:)
    @NSManaged public func removeFromTransactionHistory(_ value: WalletTransactionHistoryEntity)

    @objc(addTransactionHistory:)
    @NSManaged public func addToTransactionHistory(_ values: NSSet)

    @objc(removeTransactionHistory:)
    @NSManaged public func removeFromTransactionHistory(_ values: NSSet)

}
