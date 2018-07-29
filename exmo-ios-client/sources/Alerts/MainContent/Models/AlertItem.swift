//
//  AlertItem.swift
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

class AlertItem: SegueBlock, Mappable {
    var id: String = ""
    var currencyPairName: String! = ""
    var currencyPairPriceAtCreateMoment: Double! = 0.0
    var topBoundary: Double? = 0.0
    var bottomBoundary: Double? = 0.0
    var status = AlertStatus.Inactive
    var dateCreated: Date! = Date()
    var note: String? = nil
    var isPersistentNotification: Bool = false
    var isApproved: Bool = false
    
    init(id: String, currencyPairName: String!, currencyPairPriceAtCreateMoment: Double!, note: String?, topBoundary: Double?, bottomBoundary: Double?, status: AlertStatus = .None, isPersistentNotification: Bool) {
        self.id = id
        self.currencyPairName = currencyPairName
        self.currencyPairPriceAtCreateMoment = currencyPairPriceAtCreateMoment
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
        self.currencyPairName <- map["currency"]
        self.currencyPairPriceAtCreateMoment <- map["bottom_bound"] // TODO-Alerts: update this hardcode
        self.topBoundary      <- map["upper_bound"]
        self.bottomBoundary   <- map["bottom_bound"]
        self.status           <- map["status"]
        self.dateCreated      <- (map["timestamp"], DateTransform())
        self.note             <- map["description"]
        self.isPersistentNotification <- map["approved"]            // TODO-Alerts: add on server side
        self.isApproved       <- map["approved"]
    }
    
    func getDataAsText() -> String {
        return    "id: \(id)\n"
                + "currencyPairName: \(currencyPairName!)\n"
                + "currencyPairPriceAtCreateMoment: \(currencyPairPriceAtCreateMoment!)\n"
                + "topBoundary: \(topBoundary!)\n"
                + "bottomBoundary: \(bottomBoundary!)\n"
                + "status: \(status)\n"
                + "dateCreated: \(dateCreated)\n"
                + "isPersistentNotification: \(isPersistentNotification)\n"
                + "note: \(note ?? "empty")\n"
    }

    func updateData(newData: AlertItem) {
        self.currencyPairName = newData.currencyPairName
        self.currencyPairPriceAtCreateMoment = newData.currencyPairPriceAtCreateMoment
        self.note = newData.note
        self.topBoundary = newData.topBoundary
        self.bottomBoundary = newData.bottomBoundary
        self.status = newData.status
        self.isPersistentNotification = newData.isPersistentNotification
    }
    
    func getCurrencyPairForDisplay() -> String {
        return currencyPairName.replacingOccurrences(of: "_", with: "/")
    }
}
