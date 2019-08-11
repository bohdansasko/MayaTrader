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

extension NotificationCenter {
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: nil)
    }
    
    func post(name aName: NSNotification.Name, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: aName, object: nil, userInfo: aUserInfo)
    }
    
}
