//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

// MARK: - VinsoResponseCode

enum VinsoResponseCode: Int {
    // request processed successful
    case succeed      = 200
    // unknown error
    case error        = 0
    // unknown client error
    case clientError  = 429
    // client has missed pass some argument or pass something wrong
    case badRequest   = 400
    // client hasn't authorized
    case unauthorized = 401
    // server cannot find something (e.g. alert with passed wrong id)
    case notFound     = 404
    // something went wrong in backend (it's server issue)
    case internalServerError = 500
}

// MARK: - ServerMessage

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
    case getCurrenciesLikeString = 17
    
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
        case .registerAPNsDeviceToken: return "registerAPNsDeviceToken"
        case .subscriptionConfigs : return "subscriptionConfigs"
        case .setSubscriptionType : return "setSubscriptionType"
        case .getAlertsInfo       : return "getAlertsInfo"
        case .getCurrencyGroup    : return "getCurrencyGroup"
        case .getSelectedCurrencies : return "getSelectedCurrencies"
        case .getCurrenciesLikeString : return "getCurrenciesLikeString"
        }
    }
}

// MARK: - CHStockExchange

enum CHStockExchange: String {
    case exmo     = "exmo"
    case btcTrade = "btc_trade"
}

extension CHStockExchange {
    
    var description: String {
        switch self {
        case .exmo:
            return "EXMO"
        case .btcTrade:
            return "BTC TRADE"
        }
    }
    
}

// MARK: - CHVinsoAPIError

enum CHVinsoAPIError: String, Error {
    case unknown      = "Unknown error."
    case noConnection = "Can't establish connection. Please, try again through a few minutes or write us."
    case socketClosed = "Your connection was interrupted. Please, try again through a few minutes or write us if issue will be repeated again."
    case badRequest   = "Wrong request. Please verify it."
    case unauthorized = "Can't accomplish operation. User must be authorized."
    case notFound     = "Resource hasn't been found."
    case serverError  = "Something went wrong."
}
