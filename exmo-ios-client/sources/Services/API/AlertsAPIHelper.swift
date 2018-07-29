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
    //
    // @MARK: public methods
    //
    static func prepareJSONForCreateAlert(alertItem: AlertItem) -> JSON {
        let alertJSONData = getAlertMessage(
            upper_bound : alertItem.topBoundary!,
            bottom_bound: alertItem.bottomBoundary!,
            currency    : alertItem.currencyPairName,
            description : alertItem.note == nil ? "" : alertItem.note!,
            priceAtCreateMoment: alertItem.priceAtCreateMoment,
            isPersistent: alertItem.isPersistentNotification
        )
        
        return alertJSONData
    }
    
    static func prepareJSONForUpdateAlert(alertItem: AlertItem) -> JSON {
        var alertJSONData = getAlertMessage(
            upper_bound : alertItem.topBoundary!,
            bottom_bound: alertItem.bottomBoundary!,
            currency    : alertItem.currencyPairName,
            description : alertItem.note == nil ? "" : alertItem.note!,
            priceAtCreateMoment: alertItem.priceAtCreateMoment,
            isPersistent: alertItem.isPersistentNotification
        )
        alertJSONData["server_alert_id"] = JSON(alertItem.id)
        alertJSONData["status"] = JSON(alertItem.status.rawValue)
        
        return alertJSONData
    }
    
    static func prepareJSONForDeleteAlert(alertId: String) -> JSON {        
        return [
            "server_alert_id" : alertId
        ]
    }
    
    //
    // @MARK: private methods
    //
    static private func getAlertMessage(upper_bound: Double, bottom_bound: Double, currency: String, description: String, status: AlertStatus = .None, timestamp: Double = -1.0, last_update: Double = -1.0, server_alert_id: Int = -1, priceAtCreateMoment: Double, isPersistent: Bool) -> JSON {
        var jsonData: JSON = [
            "upper_bound" : upper_bound,
            "bottom_bound" : bottom_bound,
            "currency" : currency,
            "description" : description,
            "priceAtCreateMoment" : priceAtCreateMoment,
            "isPersistent" : isPersistent
        ]
        
        if status != .None {
            jsonData["status"] = JSON(status.rawValue)
            jsonData["timestamp"] = JSON(timestamp)
            jsonData["last_update"] = JSON(last_update)
            jsonData["server_alert_id"] = JSON(server_alert_id)
        }
        
        return jsonData
    }
}
