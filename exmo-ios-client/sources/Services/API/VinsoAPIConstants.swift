//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

enum VinsoResponseCode: Int {
    case succeed     = 200
    case error       = 0
    case clientError = 429
}

enum ServerMessage: Int {
    case bad                 = -1
    case connect             = 0
    case registration        = 1
    case authorization       = 2
    case confirmRegistration = 3
    case createAlert         = 4
    case updateAlert         = 5
    case deleteAlert         = 6
    case fireAlert           = 7
    case resetUser           = 9
    case alertsHistory       = 10
    case registerAPNsDeviceToken = 11
    case subscriptionConfigs = 12
    case setSubscriptionType = 13
    case getAlertsInfo       = 14
    case getCurrencyGroup    = 15
    case getSelectedCurrencies = 16
    
    var description: String {
        switch self {
        case .bad                 : return "bad"
        case .connect             : return "connect"
        case .registration        : return "registration"
        case .authorization       : return "authorization"
        case .confirmRegistration : return "confirmRegistration"
        case .createAlert         : return "createAlert"
        case .updateAlert         : return "updateAlert"
        case .deleteAlert         : return "deleteAlert"
        case .fireAlert           : return "fireAlert"
        case .resetUser           : return "resetUser"
        case .alertsHistory       : return "alertsHistory"
        case .registerAPNsDeviceToken : return "registerAPNsDeviceToken"
        case .subscriptionConfigs : return "subscriptionConfigs"
        case .setSubscriptionType : return "setSubscriptionType"
        case .getAlertsInfo       : return "getAlertsInfo"
        case .getCurrencyGroup    : return "getCurrencyGroup"
        case .getSelectedCurrencies : return "getSelectedCurrencies"
        }
    }
}

enum CHVinsoAPIError: String, Error {
    case unknown = "Unknown error."
    case noConnection = "Can't establish connection. Please, try again through a few minutes or write us."
    case socketClosed = "Your connection was interrupted. Please, try again through a few minutes or write us."
}

enum CHStockExchange: String {
    case exmo     = "exmo"
    case btcTrade = "btc_trade"
}

enum ConnectionNotification: String, NotificationName {
    case connectedSuccess
    case connectionError
    
    case authorizationSuccess
    case authorizationError
}

enum AlertsNotification: String, NotificationName {
    case loadedHistorySuccess
    case createdAlertSuccess
    case updatedAlertSuccess
    case deletedAlertSuccess
    
    case loadedHistoryError
    case createdAlertError
    case updatedAlertError
    case deletedAlertError
}
