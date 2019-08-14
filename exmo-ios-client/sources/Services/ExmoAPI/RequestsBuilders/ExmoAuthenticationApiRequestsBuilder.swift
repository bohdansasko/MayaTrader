//
//  ExmoAuthenticationApiRequestsBuilder.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Alamofire

protocol ExmoAuthenticationApiRequests {
    func clearAuthorizationData()
    func setAuthorizationData(apiKey: String, secretKey: String)
    func getAuthenticatedRequest(postDictionary: [String: Any], method: String) -> URLRequest
    func getUserInfoRequest() -> URLRequest
    func getOpenOrdersRequest() -> URLRequest
    func getCancelledOrdersRequest(limit: Int, offset: Int) -> URLRequest
    func getUserTradesRequest(limit: Int, offset: Int, pairs: String) -> URLRequest
    func getCreateOrderRequest(pair: String, quantity: Double, price: Double, type: String) -> URLRequest
    func getCancelOrderRequest(id: Int64) -> URLRequest
}

// MARK: - ExmoAuthenticationApiRequests

extension ExmoApiRequestsBuilder: ExmoAuthenticationApiRequests {
    
    func clearAuthorizationData() {
        setAuthorizationData(apiKey: "", secretKey: "")
    }
    
    func setAuthorizationData(apiKey: String, secretKey: String) {
        ConnectionConfig.apiKey = apiKey
        ConnectionConfig.apiSecret = secretKey
    }
    
    internal func getAuthenticatedRequest(postDictionary: [String: Any], method: String) -> URLRequest {
        var post: String = ""
        var index: Int = 0
        for (key, value) in postDictionary {
            if (index == 0) {
                post = "\(key)=\(value)"
            } else {
                post = "\(post)&\(key)=\(value)"
            }
            index += 1
        }
        post = "\(post)&nonce=\(nonce)"
        nonce += 1
        print(post)
        
        let apiUrl = URL(string: ConnectionConfig.apiUrl + method)!
        let requestBodyData = post.data(using: .utf8)
        let signedPost = hmacForKeyAndData(key: ConnectionConfig.apiSecret, data: post)
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(ConnectionConfig.apiKey, forHTTPHeaderField: "Key")
        request.setValue(signedPost, forHTTPHeaderField: "Sign")
        request.httpBody = requestBodyData
        
        return request
    }
    
    
    func getUserInfoRequest() -> URLRequest {
        let post: [String: Any] = [:]
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.userInfo.rawValue)
    }
    
    func getOpenOrdersRequest() -> URLRequest {
        return getAuthenticatedRequest(postDictionary: [:], method: MethodId.openOrders.rawValue)
    }
    
    func getCancelledOrdersRequest(limit: Int, offset: Int) -> URLRequest {
        var post: [String: Any] = [:]
        post["limit"] = limit
        post["offset"] = offset
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.cancelledOrders.rawValue)
    }
    
    func getUserTradesRequest(limit: Int = 100, offset: Int = 0, pairs: String = "") -> URLRequest {
        var post: [String: Any] = [:]
        post["pair"] = pairs
        post["limit"] = limit
        post["offset"] = offset
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.userTrades.rawValue)
    }
    
    func getCreateOrderRequest(pair: String, quantity: Double, price: Double, type: String) -> URLRequest {
        var post: [String: Any] = [:]
        post["pair"] = pair
        post["quantity"] = quantity
        post["price"] = price
        post["type"] = type
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.orderCreate.rawValue)
    }
    
    func getCancelOrderRequest(id: Int64) -> URLRequest {
        var post: [String: Any] = [:]
        post["order_id"] = id
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.orderCancel.rawValue)
    }
    
}
