//
//  AppDelegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/20/18.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import CommonCrypto

public class ExmoApiHandler {
    static let shared = ExmoApiHandler()
    
    fileprivate struct ConnectionConfig {
        static let API_URL = "https://api.exmo.com/v1/"
        static var API_KEY = "your_key"
        static var API_SECRET = "your_secret"
        static var NONCE = "Nonce"
    }

    private var nonce: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: ConnectionConfig.NONCE)
            return (value == 0) ? calculateInitialNonce(): value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ConnectionConfig.NONCE)
        }
    }

    private init() {
        // do nothing
    }
}

//
// @MARK: common methods
//
extension ExmoApiHandler {
    fileprivate func getResponseFromServerForPost(postDictionary: [String: Any], method: String) -> Data? {
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
        
        let signedPost = hmacForKeyAndData(key: ConnectionConfig.API_SECRET, data: post)
        let strUrlValue = ConnectionConfig.API_URL as String + method
        let request = NSMutableURLRequest(url: URL(string: strUrlValue)!)
        
        request.httpMethod = "POST"
        request.setValue(ConnectionConfig.API_KEY, forHTTPHeaderField: "Key")
        request.setValue(signedPost, forHTTPHeaderField: "Sign")
        
        let requestBodyData = post.data(using: .utf8)
        request.httpBody = requestBodyData
        
        // var error: NSError?
        let theResponse: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        let responseData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: theResponse) as Data?
//        if (error != nil){
//            return nil
//        }
        
        return responseData
    }
    
    private func calculateInitialNonce()-> Int {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = "yyyy-MM-dd HH:mm:ss xxxx"
        let timeStamp = Date().timeIntervalSince(dataFormat.date(from: "2012-04-18 00:00:03 +0600")!)
        let currentNonce = Int(timeStamp)
        return currentNonce
    }
    
    
    private func hmacForKeyAndData(key: String, data: String)-> String {
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
}

//
// @MARK: service methods
//
extension ExmoApiHandler {
    func setAuthorizationData(apiKey: String, secretKey: String) {
        ConnectionConfig.API_KEY = apiKey
        ConnectionConfig.API_SECRET = secretKey
    }
    
    func loadUserInfo()-> Data? {
        print("start user_info")
        let post: [String: Any] = [:]
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_info")
    }
    
    func loadCanceledOrders(limit: Int, offset: Int)-> Data? {
        print("start user_cancelled_orders")
        var post: [String: Any] = [:]
        post["limit"] = limit
        post["offset"] = offset
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_cancelled_orders")
    }
    
    func loadUserTrades(limit: Int = 0, offset: Int = 100)-> Data? {
        print("start user_trades")
        var post: [String: Any] = [:]
        post["limit"] = limit
        post["offset"] = offset
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_trades")
    }
}


class ExmoAccountController {
    func getAllCurrenciesOnExmo() -> [String] { // TODO-REF: use cache instead this. cache should update every login
        return [
            "USD","EUR","RUB","PLN","UAH","BTC","LTC","DOGE","DASH","ETH","WAVES","ZEC","USDT","XMR","XRP","KICK","ETC","BCH"
        ]
    }
    
    func getAllPairsOnExmo() -> [String] {
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

extension ExmoAccountController {
    func login(apiKey: String, secretKey: String) {
        ExmoApiHandler.shared.setAuthorizationData(apiKey: apiKey, secretKey: secretKey)
        
        let result = ExmoApiHandler.shared.loadUserInfo()
        let jsonString = String(data: result!, encoding: .utf8)
        
        print("loaded exmo userInfo: \(jsonString!)")
        
        if let requestError = RequestError(JSONString: jsonString!) {
            print("qr data doesn't validate: \(requestError.error!)")
            AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
            return
        }
        
        guard let userData = User(JSONString: jsonString!) else {
            AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
            return
        }
        
        if let walletInfo = WalletModel(JSONString: jsonString!) {
            userData.walletInfo = walletInfo
        }
        userData.qrModel = QRLoginModel(exmoIdentifier: SDefaultValues.ExmoIdentifier.rawValue, key: apiKey, secret: secretKey)
        
        AppDelegate.session.setUserModel(userData: userData)
    }
}
