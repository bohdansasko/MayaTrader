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
    var currencyPairName: String! = ""
    var currencyPairPriceAtCreateMoment: Double! = 0.0
    var note: String? = nil
    var topBoundary: Double? = 0.0
    var bottomBoundary: Double? = 0.0
    var status = AlertStatus.Inactive
    var dateCreated: Date! = Date()
    var id: String = ""
    
    init(currencyPairName: String!, currencyPairPriceAtCreateMoment: Double!, note: String?, topBoundary: Double?, bottomBoundary: Double?, status: AlertStatus = .None) {
        self.currencyPairName = currencyPairName
        self.currencyPairPriceAtCreateMoment = currencyPairPriceAtCreateMoment
        self.note = note
        self.topBoundary = topBoundary
        self.bottomBoundary = bottomBoundary
        self.status = status
        self.dateCreated = Date()
    }
}
