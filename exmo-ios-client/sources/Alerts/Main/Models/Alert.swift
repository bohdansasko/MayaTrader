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
    case None
    case Active
    case Inactive
}

class Alert: SegueBlock, Mappable {
    var id: String = ""
    var currencyCode: String! = ""
    var priceAtCreateMoment: Double! = 0.0
    var topBoundary: Double? = 0.0
    var bottomBoundary: Double? = 0.0
    var status = AlertStatus.Inactive
    var dateCreated: Date! = Date()
    var note: String? = nil
    var isPersistentNotification: Bool = false
    var isApproved: Bool = false
    
    init(id: String, currencyPairName: String!, priceAtCreateMoment: Double!, note: String?, topBoundary: Double?, bottomBoundary: Double?, status: AlertStatus = .Active, isPersistentNotification: Bool) {
        self.id = id
        self.currencyCode = currencyPairName
        self.priceAtCreateMoment = priceAtCreateMoment
        self.note = note
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
        self.id               <- map["server_alert_id"]
        self.currencyCode <- map["currency"]
        self.priceAtCreateMoment <- map["priceAtCreateMoment"]
        self.topBoundary      <- map["upper_bound"]
        self.bottomBoundary   <- map["bottom_bound"]
        self.status           <- map["status"]
        self.dateCreated      <- (map["timestamp"], DateTransform())
        self.note             <- map["description"]
        self.isPersistentNotification <- map["isPersistent"]
        self.isApproved       <- map["approved"]
    }
    
    func getDataAsText() -> String {
        return    "id: \(id)\n"
                + "currencyPairName: \(currencyCode!)\n"
                + "priceAtCreateMoment: \(priceAtCreateMoment!)\n"
                + "topBoundary: \(topBoundary!)\n"
                + "bottomBoundary: \(bottomBoundary!)\n"
                + "status: \(status)\n"
                + "dateCreated: \(dateCreated.debugDescription)\n"
                + "isPersistentNotification: \(isPersistentNotification)\n"
                + "note: \(note ?? "empty")\n"
    }

    func updateData(newData: Alert) {
        self.currencyCode = newData.currencyCode
        self.priceAtCreateMoment = newData.priceAtCreateMoment
        self.note = newData.note
        self.topBoundary = newData.topBoundary
        self.bottomBoundary = newData.bottomBoundary
        self.status = newData.status
        self.isPersistentNotification = newData.isPersistentNotification
    }
    
    func formatedDate() -> String {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = "dd.MM.yyyy HH:mm"
        return dataFormat.string(from: self.dateCreated)
    }
}
