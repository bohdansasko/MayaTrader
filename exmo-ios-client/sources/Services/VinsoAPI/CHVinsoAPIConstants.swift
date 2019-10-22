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
    // client's app api is deprecated, app must be updated for using.
    case apiVersionNotSupported = 505
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
    case getSelectedCurrencies   = 16
    case getCurrenciesLikeString = 17
    case getUserBalance          = 18
    case getCurrencyCandles      = 19
    
    var description: String {
        switch self {
        case .bad                    : return "bad"
        case .connect                : return "connect"
        case .registration           : return "registration"
        case .authorization          : return "authorization"
        case .confirmRegistration    : return "confirmRegistration"
        case .createAlert            : return "createAlert"
        case .updateAlert            : return "updateAlert"
        case .deleteAlert            : return "deleteAlert"
        case .fireAlert              : return "fireAlert"
        case .resetUser              : return "resetUser"
        case .alertsHistory          : return "alertsHistory"
        case .registerAPNsDeviceToken: return "registerAPNsDeviceToken"
        case .subscriptionConfigs    : return "subscriptionConfigs"
        case .setSubscriptionType    : return "setSubscriptionType"
        case .getAlertsInfo          : return "getAlertsInfo"
        case .getCurrencyGroup       : return "getCurrencyGroup"
        case .getSelectedCurrencies  : return "getSelectedCurrencies"
        case .getCurrenciesLikeString: return "getCurrenciesLikeString"
        case .getUserBalance         : return "getUserBalance"
        case .getCurrencyCandles     : return "getCurrencyCandles"
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
            return "BTC-TRADE"
        }
    }
    
}

enum CHVinsoAPIError: String, Error {
    case unknown                = "ERROR_UNKNOWN"
    case noConnection           = "ERROR_NO_CONNECTION"
    case socketClosed           = "ERROR_SOCKET_CLOSED"
    case badRequest             = "ERROR_BAD_REQUEST"
    case unauthorized           = "ERROR_UNAUTHORIZED"
    case notFound               = "ERROR_RESOURCE_NOT_FOUND"
    case serverError            = "ERROR_UNDEFINED"
    case missingRequiredParams  = "ERROR_MISSING_REQUIRED_PARAMS"
    case reachedCurrenciesLimit = "ERROR_REACHED_CURRENCIES_LIMIT"
    
    var localizedDescription: String {
        return self.rawValue.localized
    }

}
