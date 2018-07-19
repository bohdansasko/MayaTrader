//
//  AlertsDisplayModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class AlertsDisplayModel {
    private var alertsItems: [AlertItem] = []
    
    func setAlerts(alerts: [AlertItem]) {
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

    func getCellItem(byRow row: Int) -> AlertItem? {
        return self.isValidIndex(index: row) ? self.alertsItems[row] : nil
    }
    
    func appendAlert(alertItem: AlertItem) {
        self.alertsItems.insert(alertItem, at: 0)
    }
    
    func reverseStatus(index: Int) {
        if self.isValidIndex(index: index) {
            switch self.alertsItems[index].status {
            case .Active:
                self.alertsItems[index].status = .Pause
            case .Pause:
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
