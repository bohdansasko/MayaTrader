//
//  AlertsAPIHelper.swift
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
        return [
            "request_type" : ServerMessage.DeleteAlert.rawValue,
            "alerts_id" : [id]
        ]
    }
    
    static func getJSONForAlertsHistory() -> JSON {
        return [
            "request_type" : ServerMessage.AlertsHistory.rawValue,
        ]
    }
    
    //
    // @MARK: private methods
    //
    static private func getAlertMessage(requestType: ServerMessage, alert: Alert) -> JSON {
        var jsonData: JSON = [
            "request_type": requestType.rawValue,
            "currency" : alert.currencyCode,
            "price_at_create_moment" : String(alert.priceAtCreateMoment),
            "alert_status": alert.status.rawValue,
            "timestamp" : Date().timeIntervalSince1970,
            "is_persistent" : alert.isPersistentNotification
        ]

        jsonData["upper_bound"] = JSON(String(alert.topBoundary ?? ""))
        jsonData["bottom_bound"] =  JSON(String(alert.bottomBoundary ?? ""))
        jsonData["description"] =  JSON(alert.description ?? "")
        
        return jsonData
    }
}
