//
//  AlertsModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class AlertsModel {
    var items: [Alert] = [
//        Alert(id: "1", currencyPairName: "BTC_USD", priceAtCreateMoment: 8000, note: "Nothing", topBoundary: 1000, bottomBoundary: 2000, isPersistentNotification: true),
//        Alert(id: "2", currencyPairName: "BTC_EUR", priceAtCreateMoment: 6000, note: "Nothing", topBoundary: 6900.965, bottomBoundary: 3670.89641, status: .inactive, isPersistentNotification: false)
    ]
    
    func removeItem(atRow row: Int) {
        if isValidIndex(index: row) {
            items.remove(at: row)
        }
    }
    
    func setState(forItem row: Int, status: AlertStatus) {
        if isValidIndex(index: row) {
            items[row].status = status
        }
    }
    
    func getStatus(forItem row: Int) -> AlertStatus {
        return isValidIndex(index: row)
                    ? items[row].status
                    : .active
    }
    
    func getCountMenuItems() -> Int {
        return items.count
    }

    func getCellItem(byRow row: Int) -> Alert? {
        return isValidIndex(index: row) ? items[row] : nil
    }

    func filter(_ closure: (Alert) -> Bool) -> [Alert] {
        return items.filter(closure)
    }
    
    func append(alertItem: Alert) {
        items.insert(alertItem, at: 0)
    }

    func getIndexById(alertId: Int) -> Int {
        let index = items.index(where: { $0.id == alertId })
        return index ?? -1
    }
    
    func removeItem(byId id: Int) {
        let index = getIndexById(alertId: id)
        if isValidIndex(index: index) {
            items.remove(at: index)
        }
    }

    func updateAlert(alertItem: Alert) {
        guard let foundAlert = items.first(where: { $0.id == alertItem.id }) else {
            return
        }
        foundAlert.updateData(newData: alertItem)
    }

    func reverseStatus(index: Int) {
        if isValidIndex(index: index) {
            switch items[index].status {
            case .active:
                items[index].status = .inactive
            case .inactive:
                items[index].status = .active
            }
        }
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
    
    private func isValidIndex(index: Int) -> Bool {
        return index > -1 && index < items.count
    }
}
