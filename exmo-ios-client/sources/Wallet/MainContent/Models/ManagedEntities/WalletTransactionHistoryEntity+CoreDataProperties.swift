//
//  WalletTransactionHistoryEntity+CoreDataProperties.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//
//

import Foundation
import CoreData


extension WalletTransactionHistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletTransactionHistoryEntity> {
        return NSFetchRequest<WalletTransactionHistoryEntity>(entityName: "WalletTransactionHistoryEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var orderId: Int64
    @NSManaged public var pair: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Double
    @NSManaged public var tradeId: Int32
    @NSManaged public var type: String?
    @NSManaged public var wallet: WalletEntity?

}
