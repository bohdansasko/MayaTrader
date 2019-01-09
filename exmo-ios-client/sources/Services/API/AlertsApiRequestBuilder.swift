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
        return getAlertMessage(requestType: .CreateAlert, alert: alert)
    }

    static func getJSONForUpdateAlert(alert: Alert) -> JSON {
        var alertJSONData = getAlertMessage(requestType: .UpdateAlert, alert: alert)
        alertJSONData["alert_id"] = JSON(alert.id)
        alertJSONData["alert_status"] = JSON(alert.status.rawValue)
        
        return alertJSONData
    }
    
    static func getJSONForDeleteAlert(withId id: Int) -> JSON {
        return getJSONForDeleteAlerts(withId: [id])
    }

    static func getJSONForDeleteAlerts(withId ids: [Int]) -> JSON {
        return [
            "request_type" : ServerMessage.DeleteAlert.rawValue,
            "alerts_id" : ids
        ]
    }

    static func getJSONForAlertsHistory() -> JSON {
        return [
            "request_type" : ServerMessage.AlertsHistory.rawValue,
        ]
    }

    static private func getAlertMessage(requestType: ServerMessage, alert: Alert) -> JSON {
        let upperBound = alert.topBoundary == nil ? JSON.null : JSON(String(alert.topBoundary!))
        let bottomBound = alert.bottomBoundary == nil ? JSON.null : JSON(String(alert.bottomBoundary!))
        return [
            "request_type": requestType.rawValue,
            "currency" : alert.currencyCode,
            "price_at_create_moment" : String(alert.priceAtCreateMoment),
            "alert_status": alert.status.rawValue,
            "timestamp" : Date().timeIntervalSince1970,
            "is_persistent" : alert.isPersistentNotification,
            "upper_bound": upperBound,
            "bottom_bound": bottomBound,
            "description": alert.description ?? ""
        ]
    }
}
