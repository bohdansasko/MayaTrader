//
//  User+CoreDataProperties.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//
//

import Foundation
import CoreData

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var uid: Int64
    @NSManaged public var jsonBalances: String?
    
    @NSManaged public var key: String?
    @NSManaged public var secret: String?
}
