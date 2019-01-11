//
//  Alert.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper

enum AlertStatus: Int {
    case active = 0
    case inactive = 1

    func description() -> String {
        switch self {
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        }
    }
}

class Alert: SegueBlock, Mappable {
    var id: Int = 0
    var currencyCode: String = ""
    var priceAtCreateMoment: Double = 0.0
    var topBoundary: Double?
    var bottomBoundary: Double?
    var status = AlertStatus.active
    var dateCreated: Date = Date()
    var description: String?
    var isPersistentNotification: Bool = false
    
    init(id: Int, currencyPairName: String, priceAtCreateMoment: Double, description: String?,
         topBoundary: Double?, bottomBoundary: Double?, status: AlertStatus = .active, isPersistentNotification: Bool) {
        self.id = id
        self.currencyCode = currencyPairName
        self.priceAtCreateMoment = priceAtCreateMoment
        self.description = description
        self.topBoundary = topBoundary
        self.bottomBoundary = bottomBoundary
        self.status = status
        self.dateCreated = Date()
        self.isPersistentNotification = isPersistentNotification
    }
    
    required init?(map: Map) {
        // do nothing
    }
    
    func mapping(map: Map) {
        let transform = TransformOf<Double, String>(
            fromJSON: { $0 == nil ? nil : Double($0!) },
            toJSON: { $0 == nil ? nil : String($0!) }
        )
        
        id                  <- map["alert_id"]
        currencyCode        <- map["currency"]
        priceAtCreateMoment <- (map["price_at_create_moment"], transform)
        topBoundary      <- (map["upper_bound"], transform)
        bottomBoundary   <- (map["bottom_bound"], transform)
        status           <- map["alert_status"]
        dateCreated      <- (map["timestamp"], DateTransform())
        description             <- map["description"]
        isPersistentNotification <- map["is_persistent"]
    }
    
    func getDataAsText() -> String {
        return    "id: \(id)\n"
                + "currencyPairName: \(currencyCode)\n"
                + "priceAtCreateMoment: \(priceAtCreateMoment)\n"
                + "topBoundary: \(topBoundary ?? -1)\n"
                + "bottomBoundary: \(bottomBoundary ?? -1)\n"
                + "status: \(status)\n"
                + "dateCreated: \(dateCreated.debugDescription)\n"
                + "isPersistentNotification: \(isPersistentNotification)\n"
                + "description: \(description ?? "empty")\n"
    }

    func updateData(newData: Alert) {
        currencyCode = newData.currencyCode
        priceAtCreateMoment = newData.priceAtCreateMoment
        description = newData.description
        topBoundary = newData.topBoundary
        bottomBoundary = newData.bottomBoundary
        status = newData.status
        isPersistentNotification = newData.isPersistentNotification
    }
    
    func formatedDate() -> String {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = "dd.MM.yyyy HH:mm"
        return dataFormat.string(from: dateCreated)
    }
}
