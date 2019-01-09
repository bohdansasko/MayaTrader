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
        return ["request_type" : ServerMessage.Connect.rawValue]
    }
    
    static func buildAuthorizationRequest() -> JSON {
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else {
            return JSON()
        }
        
        return [
            "request_type": ServerMessage.Authorization.rawValue,
            "udid": udid,
        ]
    }

    static func buildRegisterAPNSDeviceTokenRequest(_ deviceToken: String) -> JSON {
        return [
            "request_type": ServerMessage.RegisterAPNsDeviceToken.rawValue,
            "apns_token": deviceToken
        ]
    }
}