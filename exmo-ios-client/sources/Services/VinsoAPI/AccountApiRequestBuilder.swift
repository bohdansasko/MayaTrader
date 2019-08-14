//
//  AccountApiRequestBuilder.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import SwiftyJSON

class AccountApiRequestBuilder {
    static func buildConnectRequest() -> JSON {
        return ["request_type" : ServerMessage.connect.rawValue]
    }

    static func buildResetUser() -> JSON {
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else {
            return JSON()
        }

        return [
            "request_type": ServerMessage.resetUser.rawValue,
            "udid": udid
        ]
    }

    static func buildAuthorizationRequest() -> JSON {
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else {
            return JSON()
        }
        
        return [
            "request_type": ServerMessage.authorization.rawValue,
            "udid": udid
        ]
    }

    static func buildRegisterAPNSDeviceTokenRequest(_ deviceToken: String) -> JSON {
        return [
            "request_type": ServerMessage.registerAPNsDeviceToken.rawValue,
            "apns_token": deviceToken
        ]
    }

    static func buildGetSubscriptionConfigsRequest() -> JSON {
        return [
            "request_type": ServerMessage.subscriptionConfigs.rawValue
        ]
    }

    static func buildSetSubscriptionRequest(_ subscriptionId: Int) -> JSON {
        return [
            "request_type": ServerMessage.setSubscriptionType.rawValue,
            "type": subscriptionId
        ]
    }
}
