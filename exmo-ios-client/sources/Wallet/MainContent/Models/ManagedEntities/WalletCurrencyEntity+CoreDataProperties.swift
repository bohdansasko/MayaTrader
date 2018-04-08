//
//  WalletCurrencyEntity+CoreDataProperties.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//
//

import Foundation
import CoreData


extension WalletCurrencyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletCurrencyEntity> {
        return NSFetchRequest<WalletCurrencyEntity>(entityName: "WalletCurrencyEntity")
    }

    @NSManaged public var balance: Double
    @NSManaged public var currency: String?
    @NSManaged public var inOrders: Int32
    @NSManaged public var indexInTableView: Int32
    @NSManaged public var isFavourite: Bool
    @NSManaged public var wallet: WalletEntity?

}
