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
    private enum Config: String {
        case API_URL = "https://api.exmo.com/v1/"
        case API_KEY = "your_key"
        case API_SECRET = "your_secret"
        case NONCE = "Nonce"
    }
    

    private var api_key: String!
    private var secret_key: String!
    
    func setUserInfo(apiKey: String, secretKey: String) {
        self.api_key = apiKey
        self.secret_key = secretKey
    }
    
    private var nonce: Int {
        get{
            let value = UserDefaults.standard.integer(forKey: Config.NONCE.rawValue)
            return (value == 0) ? calculateInitialNonce(): value
        }
        set{
            UserDefaults.standard.set(newValue, forKey: Config.NONCE.rawValue)
        }
    }
    
    init() {
        setupInitValues()
    }
    
    internal func setupInitValues(){
        self.api_key = Config.API_KEY.rawValue
        self.secret_key = Config.API_SECRET.rawValue
    }
    
    public func loadUserInfo()-> Data? {
        print("start user_info")
        let post: [String: Any] = [:]
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_info")
    }
    

    public func canceledOrders(limit: Int, offset: Int)-> Data? {
        print("start user_cancelled_orders")
        var post: [String: Any] = [:]
        post["limit"] = limit
        post["offset"] = offset
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_cancelled_orders")
    }
    
    private func getResponseFromServerForPost(postDictionary: [String: Any], method: String) -> Data? {
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
        let signedPost = hmacForKeyAndData(key: secret_key, data: post)
        let strUrlValue = Config.API_URL.rawValue as String + method
        let request = NSMutableURLRequest(url: URL(string: strUrlValue)!)
        request.httpMethod = "POST"
        request.setValue(api_key, forHTTPHeaderField: "Key")
        request.setValue(signedPost, forHTTPHeaderField: "Sign")

        let requestBodyData = post.data(using: .utf8)
        request.httpBody = requestBodyData

        var error: NSError?
        let theResponse: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        let responseData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: theResponse) as Data!
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
