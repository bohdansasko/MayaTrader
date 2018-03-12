//
//  AlertsDisplayModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class AlertsDisplayModel {
    private var alertsItems: [AlertItem]
    
    init() {
        alertsItems = []
        update()
    }
    
    func update() {
        alertsItems = [
            AlertItem(currencyPairName: "BTC/USD", currencyPairPriceAtCreateMoment: 14765, note: nil, topBoundary: 15250, bottomBoundary: 13250, status: .Active, dateCreated: Date()),
            AlertItem(currencyPairName: "BTC/EUR", currencyPairPriceAtCreateMoment: 11765, note: "Can got much money", topBoundary: 14489, bottomBoundary: 9229, status: .Active, dateCreated: Date()),
            AlertItem(currencyPairName: "ETH/USD", currencyPairPriceAtCreateMoment: 1165, note: "Good shans for make money", topBoundary: 1490, bottomBoundary: 1100, status: .Active, dateCreated: Date()),

        ]
    }
    
    func removeItem(atRow row: Int) {
        alertsItems.remove(at: row)
    }
    
    func setState(forItem row: Int, status: AlertStatus) {
        alertsItems[row].status = status
    }
    
    func getStatus(forItem row: Int) -> AlertStatus {
        return alertsItems[row].status
    }
    
    func getCountMenuItems() -> Int {
        return alertsItems.count
    }

    func getCellItem(byRow row: Int) -> AlertItem {
        return alertsItems[row]
    }
}
