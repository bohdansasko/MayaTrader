//
//  ExmoPublicApiRequestsBuilder.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper

protocol ExmoPublicApiRequestsBuilder {
    func getPublicRequest(method: String) -> URLRequest
    func getTickerRequest() -> URLRequest
    func getCurrencyPairSettingsRequest() -> URLRequest
}

// MARK: - ExmoPublicApiRequestsBuilder

extension ExmoApiRequestsBuilder: ExmoPublicApiRequestsBuilder {
    
    func getPublicRequest(method: String) -> URLRequest {
        let apiUrl = URL(string: ConnectionConfig.apiUrl + method)!
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        
        return request
    }
    
    func getTickerRequest() -> URLRequest {
        let apiUrl = URL(string: "https://\(ConnectionConfig.exmoUrl)/ctrl/ticker")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
    
    func getCurrencyPairSettingsRequest() -> URLRequest {
        return getPublicRequest(method: MethodId.pairSettings.rawValue)
    }
    
}
