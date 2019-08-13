//
//  AlertsApiRequestBuilder.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON

class AlertsApiRequestBuilder {
    static func getJSONForCreateAlert(alert: Alert) -> JSON {
        return getAlertMessage(requestType: .createAlert, alert: alert)
    }

    static func getJSONForUpdateAlert(alert: Alert) -> JSON {
        var alertJSONData = getAlertMessage(requestType: .updateAlert, alert: alert)
        alertJSONData["alert_id"] = JSON(alert.id)
        alertJSONData["alert_status"] = JSON(alert.status.rawValue)
        
        return alertJSONData
    }
    
    static func getJSONForDeleteAlert(withId id: Int) -> JSON {
        return getJSONForDeleteAlerts(withIds: [id])
    }

    static func getJSONForDeleteAlerts(withIds ids: [Int]) -> JSON {
        return [
            "alerts_id" : ids
        ]
    }

    static func getJSONForAlertsHistory() -> JSON {
        return [
            "request_type" : ServerMessage.alertsHistory.rawValue,
        ]
    }

    static func getJSONForSelectedCurrencies() -> JSON {
        return [
            "request_type" : ServerMessage.getSelectedCurrencies.rawValue,
            "selected_currencies": ["BTC_USD"],
            "stock_exchange": "exmo",
            "extended": false
        ]
    }

    static private func getAlertMessage(requestType: ServerMessage, alert: Alert) -> JSON {
        let upperBound = alert.topBoundary == nil ? JSON.null : JSON(Utils.getJSONFormattedNumb(from: alert.topBoundary!))
        let bottomBound = alert.bottomBoundary == nil ? JSON.null : JSON(Utils.getJSONFormattedNumb(from: alert.bottomBoundary!))
        return [
            "currency" : alert.currencyCode,
            "price_at_create_moment" : Utils.getJSONFormattedNumb(from: alert.priceAtCreateMoment),
            "alert_status": alert.status.rawValue,
            "timestamp" : Int(Date().timeIntervalSince1970),
            "is_persistent" : alert.isPersistentNotification,
            "upper_bound": upperBound,
            "bottom_bound": bottomBound,
            "description": alert.description ?? JSON.null
        ]
    }
}
