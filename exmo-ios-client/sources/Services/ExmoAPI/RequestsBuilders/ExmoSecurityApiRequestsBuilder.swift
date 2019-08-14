//
//  ExmoSecurityApiRequestsBuilder.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import CommonCrypto

protocol ExmoSecurityApiRequestsBuilder {
    var nonce: Int { get set }
    
    func hmacForKeyAndData(key: String, data: String) -> String
    func calculateInitialNonce() -> Int
}

// MARK: - ExmoSecurityApiRequestsBuilder

extension ExmoApiRequestsBuilder: ExmoSecurityApiRequestsBuilder {
    
    var nonce: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: ConnectionConfig.nonce)
            return value == 0 ? calculateInitialNonce() : value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ConnectionConfig.nonce)
        }
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
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), cKey, Int(key.count), cData, Int(data.count), result)
        let hashString =  NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH))
        for idx in 0..<digestLen {
            hashString.appendFormat("%02x", result[idx])
        }
        return hashString as String
    }
    
}
