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
    static let exmoUrl = "exmo.me"
    static let apiUrl = "https://api.\(exmoUrl)/v1/"
    static var apiKey = "your_key"
    static var apiSecret = "your_secret"
    static var nonce = "Nonce"
}

enum MethodId: String {
    case userInfo = "user_info"
    case openOrders = "user_open_orders"
    case cancelledOrders = "user_cancelled_orders"
    case userTrades = "user_trades"
    case orderCreate = "order_create"
    case orderCancel = "order_cancel"
    case ticker = "ticker"
    case pairSettings = "pair_settings"
}

// MARK: public requests
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
    func getCancelledOrdersRequest(limit: Int, offset: Int) -> URLRequest
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
            let value = UserDefaults.standard.integer(forKey: ConnectionConfig.nonce)
            return value == 0 ? calculateInitialNonce() : value
        }
        set { UserDefaults.standard.set(newValue, forKey: ConnectionConfig.nonce) }
    }
    
    private init() {
        // do nothing
    }
}

// MARK: public API methods
extension ExmoApiRequestBuilder {
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

// MARK: Authenticated API methods
extension ExmoApiRequestBuilder {
    func clearAuthorizationData() {
        setAuthorizationData(apiKey: "", secretKey: "")
    }
    
    func setAuthorizationData(apiKey: String, secretKey: String) {
        ConnectionConfig.apiKey = apiKey
        ConnectionConfig.apiSecret = secretKey
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
        for idx in 0..<digestLen {
            hashString.appendFormat("%02x", result[idx])
        }
        return hashString as String
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
