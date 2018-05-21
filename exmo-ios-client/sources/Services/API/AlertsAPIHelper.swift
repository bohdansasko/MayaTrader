//
//  AlertsAPIHelper.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON

class AlertsAPIHelper {
    enum AlertMessageSettings: Int {
        case Topic = 0
    }
    
    enum AlertMessageType: Int {
        case Create = 0
        case Update = 1
        case Delete = 2
    }
    //
    // @MARK: public methods
    //
    static func prepareJSONForCreateAlert(alertItem: AlertItem) -> JSON {
        let alertJSONData = getAlertMessage(
            price_option: alertItem.currencyPairPriceAtCreateMoment,
            upper_bound : alertItem.topBoundary!,
            bottom_bound: alertItem.bottomBoundary!,
            currency    : alertItem.currencyPairName,
            description : alertItem.note == nil ? "" : alertItem.note!
        )
        
        return alertJSONData
    }
    
    static func prepareJSONForUpdateAlert(alertItem: AlertItem) -> JSON {
        var alertJSONData = getAlertMessage(
            price_option: alertItem.currencyPairPriceAtCreateMoment,
            upper_bound : alertItem.topBoundary!,
            bottom_bound: alertItem.bottomBoundary!,
            currency    : alertItem.currencyPairName,
            description : alertItem.note == nil ? "" : alertItem.note!
        )
        alertJSONData["server_alert_id"] = JSON(alertItem.id)
        
        return alertJSONData
    }
    
    static func prepareJSONForDeleteAlert(alertItem: AlertItem) -> JSON {
        let alertJSONData: JSON = [
            "server_alert_id" : alertItem.id
        ]
        
        return alertJSONData
    }
    
    //
    // @MARK: private methods
    //
    static private func getAlertMessage(price_option: Double, upper_bound: Double, bottom_bound: Double, currency: String, description: String, status: AlertStatus = .None, timestamp: Double = -1.0, last_update: Double = -1.0, server_alert_id: Int = -1) -> JSON {
        var jsonData: JSON = [
            "price_option" : price_option,
            "upper_bound" : upper_bound,
            "bottom_bound" : bottom_bound,
            "currency" : currency,
            "description" : description,
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
