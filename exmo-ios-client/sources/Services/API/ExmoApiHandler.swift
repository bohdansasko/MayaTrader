//
//  AppDelegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/20/18.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper
import CommonCrypto

struct ConnectionConfig {
    static let SITE_URL = "exmo.me"
    static let API_URL = "https://api.\(SITE_URL)/v1/"
    static var API_KEY = "your_key"
    static var API_SECRET = "your_secret"
    static var NONCE = "Nonce"
}

enum MethodId: String {
    case UserInfo = "user_info"
    case OpenOrders = "user_open_orders"
    case CancelledOrders = "user_cancelled_orders"
    case UserTrades = "user_trades"
    case OrderCreate = "order_create"
    case OrderCancel = "order_cancel"
    case Ticker = "ticker"
    case PairSettings = "pair_settings"
}

// @MARK: public requests
protocol ExmoPublicApiRequests {
    func getPublicRequest(method: String) -> URLRequest
    func getTickerRequest() -> URLRequest
    func getCurrencyPairSettingsRequest() -> URLRequest
}

protocol ExmoAuthenticationApiRequests {
    func clearAuthorizationData()
    func setAuthorizationData(apiKey: String, secretKey: String)
    func getAuthenticatedRequest(postDictionary: [String: Any], method: String) -> URLRequest
    func getUserInfoRequest() -> URLRequest
    func getOpenOrdersRequest() -> URLRequest
    func getCanceledOrdersRequest(limit: Int, offset: Int) -> URLRequest
    func getUserTradesRequest(limit: Int, offset: Int, pairs: String) -> URLRequest
    func getCreateOrderRequest(pair: String, quantity: Double, price: Double, type: String) -> URLRequest
    func getCancelOrderRequest(id: Int64) -> URLRequest
}

protocol IApiRequestBuilder: ExmoPublicApiRequests, ExmoAuthenticationApiRequests {
    func hmacForKeyAndData(key: String, data: String) -> String
    func calculateInitialNonce() -> Int
    
    var nonce: Int { get set }
}

public class ExmoApiRequestBuilder: IApiRequestBuilder {
    static let shared: IApiRequestBuilder = {
        return ExmoApiRequestBuilder()
    }()
    
    var nonce: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: ConnectionConfig.NONCE)
            return value == 0 ? calculateInitialNonce() : value
        }
        set { UserDefaults.standard.set(newValue, forKey: ConnectionConfig.NONCE) }
    }
    
    private init() {
        // do nothing
    }
}

// @MARK: public API methods
extension ExmoApiRequestBuilder {
    func getPublicRequest(method: String) -> URLRequest {
        let apiUrl = URL(string: ConnectionConfig.API_URL + method)!
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        
        return request
    }
    
    func getTickerRequest() -> URLRequest {
        let apiUrl = URL(string: "https://\(ConnectionConfig.SITE_URL)/ctrl/ticker")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
    
    func getCurrencyPairSettingsRequest() -> URLRequest {
        return getPublicRequest(method: MethodId.PairSettings.rawValue)
    }
}

// @MARK: Authenticated API methods
extension ExmoApiRequestBuilder {
    func clearAuthorizationData() {
        setAuthorizationData(apiKey: "", secretKey: "")
    }
    
    func setAuthorizationData(apiKey: String, secretKey: String) {
        ConnectionConfig.API_KEY = apiKey
        ConnectionConfig.API_SECRET = secretKey
    }
    
    func getAuthenticatedRequest(postDictionary: [String: Any], method: String) -> URLRequest {
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
        
        let apiUrl = URL(string: ConnectionConfig.API_URL + method)!
        let requestBodyData = post.data(using: .utf8)
        let signedPost = hmacForKeyAndData(key: ConnectionConfig.API_SECRET, data: post)
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(ConnectionConfig.API_KEY, forHTTPHeaderField: "Key")
        request.setValue(signedPost, forHTTPHeaderField: "Sign")
        request.httpBody = requestBodyData
        
        return request
    }
    
    func calculateInitialNonce() -> Int {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = "yyyy-MM-dd HH:mm:ss xxxx"
        let timeStamp = Date().timeIntervalSince(dataFormat.date(from: "2012-04-18 00:00:03 +0600")!)
        let currentNonce = Int(timeStamp)
        return currentNonce
    }
    
    func hmacForKeyAndData(key: String, data: String) -> String {
        let cKey =  key.cString(using: String.Encoding.ascii)
        let cData = data.cString(using: String.Encoding.ascii)
        let _ = [CUnsignedChar](repeatElement(0, count: Int(CC_SHA512_DIGEST_LENGTH)))
        let digestLen = Int(CC_SHA512_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        print("CCHmac")
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), cKey, Int(key.count), cData, Int(data.count), result)
        let hashString =  NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH))
        for i in 0..<digestLen {
            hashString.appendFormat("%02x", result[i])
        }
        return hashString as String
    }
    
    func getUserInfoRequest() -> URLRequest {
        let post: [String: Any] = [:]
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.UserInfo.rawValue)
    }
    
    func getOpenOrdersRequest() -> URLRequest {
        return getAuthenticatedRequest(postDictionary: [:], method: MethodId.OpenOrders.rawValue)
    }
    
    func getCanceledOrdersRequest(limit: Int, offset: Int) -> URLRequest {
        var post: [String: Any] = [:]
        post["limit"] = limit
        post["offset"] = offset
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.CancelledOrders.rawValue)
    }
    
    func getUserTradesRequest(limit: Int = 100, offset: Int = 0, pairs: String = "") -> URLRequest {
        var post: [String: Any] = [:]
        post["pair"] = pairs
        post["limit"] = limit
        post["offset"] = offset
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.UserTrades.rawValue)
    }
    
    func getCreateOrderRequest(pair: String, quantity: Double, price: Double, type: String) -> URLRequest {
        var post: [String: Any] = [:]
        post["pair"] = pair
        post["quantity"] = quantity
        post["price"] = price
        post["type"] = type
        
        return getAuthenticatedRequest(postDictionary: post, method: MethodId.OrderCreate.rawValue)
    }

    func getCancelOrderRequest(id: Int64) -> URLRequest {
        var post: [String: Any] = [:]
        post["order_id"] = id

        return getAuthenticatedRequest(postDictionary: post, method: MethodId.OrderCancel.rawValue)
    }
}

// MARK: ExmoAccountController
class ExmoAccountController {
    func getAllCurrenciesOnExmo() -> [String] { // TODO-REF: use cache instead this. cache should update every login
        return [
            "USD","EUR","RUB","PLN","UAH","BTC","LTC","DOGE","DASH","ETH","WAVES","ZEC","USDT","XMR","XRP","KICK","ETC","BCH"
        ]
    }
    
    func getAllPairsOnExmo() -> [String] { // TODO: check this method, because some currencies doesn't exists
        let currencies = getAllCurrenciesOnExmo()
        var allCombOfCurrencies = [String]()
        
        for currencyPart1 in currencies {
            for currencyPart2 in currencies {
                if currencyPart1 != currencyPart2 {
                    allCombOfCurrencies.append(currencyPart1 + "_" + currencyPart2)
                }
            }
        }
        
        return allCombOfCurrencies
    }
    
    func getAllPairsOnExmoAsStr(separator: String = ",") -> String {
        return getAllPairsOnExmo().joined(separator: separator)
    }
}
