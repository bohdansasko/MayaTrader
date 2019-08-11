//
//  Notification+Extension.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(rawValue: self.rawValue)
        }
    }
}

enum AuthorizationNotification: String, NotificationName {
    case userSignIn
    case userFailSignIn
    case userSignOut
}

enum ConnectionNotification: String, NotificationName {
    case connectedSuccess
    case connectionError
    
    case authorizationSuccess
    case authorizationError
}

enum AlertsNotification: String, NotificationName {
    case loadedHistorySuccess
    case createdAlertSuccess
    case updatedAlertSuccess
    case deletedAlertSuccess
    
    case loadedHistoryError
    case createdAlertError
    case updatedAlertError
    case deletedAlertError
}

enum IAPNotification: String, NotificationName {
    case completeTransaction
    
    case purchaseSuccess
    case purchaseError
    
    case purchased
    case expired
    case notPurchased
    
    case updateSubscription
}

enum InternetReachabilityNotification: String, NotificationName {
    case reachable
    case notReachable
}

enum CHUserInfoKeys: String {
    case reason
}

extension NotificationCenter {
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: nil)
    }
    
    func post(name aName: NSNotification.Name, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: aName, object: nil, userInfo: aUserInfo)
    }
    
}
