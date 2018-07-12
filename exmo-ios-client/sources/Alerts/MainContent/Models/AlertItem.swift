//
//  AlertItem.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

enum AlertStatus: Int {
    case None
    case Active
    case Inactive
    case Pause
}

class AlertItem {
    var id: Int = 0
    var currencyPairName: String! = ""
    var currencyPairPriceAtCreateMoment: Double! = 0.0
    var topBoundary: Double? = 0.0
    var bottomBoundary: Double? = 0.0
    var status = AlertStatus.Inactive
    var dateCreated: Date! = Date()
    var note: String? = nil
    var isPersistentNotification: Bool
    
    init(id: Int, currencyPairName: String!, currencyPairPriceAtCreateMoment: Double!, note: String?, topBoundary: Double?, bottomBoundary: Double?, status: AlertStatus = .None, isPersistentNotification: Bool) {
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
}
