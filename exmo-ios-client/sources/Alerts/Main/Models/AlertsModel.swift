//
//  AlertsModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class AlertsModel {
    private var alertsItems: [Alert] = [
        Alert(id: "1", currencyPairName: "BTC_USD", priceAtCreateMoment: 8000, note: "Nothing", topBoundary: 1000, bottomBoundary: 2000, isPersistentNotification: true),
        Alert(id: "2", currencyPairName: "BTC_EUR", priceAtCreateMoment: 6000, note: "Nothing", topBoundary: 6900.965, bottomBoundary: 3670.89641, status: .Inactive, isPersistentNotification: false)

    ]
    
    func setAlerts(alerts: [Alert]) {
        self.alertsItems = alerts
    }
    
    func removeItem(atRow row: Int) {
        if self.isValidIndex(index: row) {
            self.alertsItems.remove(at: row)
        }
    }
    
    func setState(forItem row: Int, status: AlertStatus) {
        if self.isValidIndex(index: row) {
            self.alertsItems[row].status = status
        }
    }
    
    func getStatus(forItem row: Int) -> AlertStatus {
        return self.isValidIndex(index: row)
                    ? self.alertsItems[row].status
                    : .None
    }
    
    func getCountMenuItems() -> Int {
        return self.alertsItems.count
    }

    func getCellItem(byRow row: Int) -> Alert? {
        return self.isValidIndex(index: row) ? self.alertsItems[row] : nil
    }
    
    func append(alertItem: Alert) {
        self.alertsItems.insert(alertItem, at: 0)
    }

    func getIndexById(alertId: String) -> Int {
        let index = self.alertsItems.index(where: { $0.id == alertId })
        return index ?? -1
    }
    
    func removeItem(byId id: String) {
        let index = self.getIndexById(alertId: id)
        if self.isValidIndex(index: index) {
            self.alertsItems.remove(at: index)
        }
    }

    func updateAlert(alertItem: Alert) {
        guard let foundAlert = self.alertsItems.first(where: { $0.id == alertItem.id }) else {
            return
        }
        foundAlert.updateData(newData: alertItem)
    }

    func reverseStatus(index: Int) {
        if self.isValidIndex(index: index) {
            switch self.alertsItems[index].status {
            case .Active:
                self.alertsItems[index].status = .Inactive
            case .Inactive:
                self.alertsItems[index].status = .Active
            default:
                break
            }
        }
    }
    
    func isEmpty() -> Bool {
        return self.alertsItems.isEmpty
    }
    
    private func isValidIndex(index: Int) -> Bool {
        return index > -1 && index < self.alertsItems.count
    }
}
