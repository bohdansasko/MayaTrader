//
//  AlertsNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import ObjectMapper

protocol IVinsoAlertsApiRequestBuilder {
    static func getAlertsHistoryRequest() -> URLRequest
    static func getCreateAlertRequest() -> URLRequest
    static func getDeleteAlertRequest() -> URLRequest
}

class VinsoAlertsApiRequestBuilder: IVinsoAlertsApiRequestBuilder {
    private init() {
        // do nothing
    }
    
    static func getAlertsHistoryRequest() -> URLRequest {
        return URLRequest(url: URL(string: "")!)
    }
    
    static func getCreateAlertRequest() -> URLRequest {
        return URLRequest(url: URL(string: "")!)
    }
    
    static func getDeleteAlertRequest() -> URLRequest {
        return URLRequest(url: URL(string: "")!)
    }
}
