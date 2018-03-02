//
//  WalletCurrency+CoreDataProperties.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//
//

import Foundation
import CoreData

extension WalletCurrency {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletCurrency> {
        return NSFetchRequest<WalletCurrency>(entityName: "WalletCurrency")
    }

    @NSManaged public var balance: Double
    @NSManaged public var currency: String?
    @NSManaged public var inOrders: Int32

}
