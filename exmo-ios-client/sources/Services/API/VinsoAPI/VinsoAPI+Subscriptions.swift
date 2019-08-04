//
//  VinsoAPI+Subscriptions.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

// MARK: - Manage subscriptions

extension VinsoAPI {
    
    func subscribeOnIAPNotifications() {
        AppDelegate.notificationController.addObserver(
            self,
            selector: #selector(onProductSubscriptionActive(_ :)),
            name: IAPService.Notification.updateSubscription.name)
        AppDelegate.notificationController.addObserver(
            self,
            selector: #selector(onPurchaseError(_ :)),
            name: IAPService.Notification.purchaseError.name)
    }
    
    func unsubscribeFromNotifications() {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    func setSubscriptionType(_ packageType: SubscriptionPackageType) {
        print("\(String(describing: self)) => \(#function)")
        let msg = AccountApiRequestBuilder.buildSetSubscriptionRequest(packageType.rawValue)
        socketManager.send(message: msg)
    }
    
    func loadAvailableSubscriptions() {
        print("\(String(describing: self)) => \(#function)")
        let msg = AccountApiRequestBuilder.buildGetSubscriptionConfigsRequest()
        socketManager.send(message: msg)
    }
    
}

// MARK: - Notification handlers

private extension VinsoAPI {

    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let subscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? ISubscriptionPackage else {
            print("\(#function) => can't convert notification container to IAPProduct")
            if AppDelegate.vinsoAPI.isAuthorized {
                AppDelegate.vinsoAPI.setSubscriptionType(.freeWithAds)
            }
            return
        }
        
        if AppDelegate.vinsoAPI.isAuthorized {
            AppDelegate.vinsoAPI.setSubscriptionType(subscriptionPackage.type)
        }
    }
    
    @objc
    func onPurchaseError(_ notification: Notification) {
        if AppDelegate.vinsoAPI.isAuthorized {
            AppDelegate.vinsoAPI.setSubscriptionType(.freeWithAds)
        }
    }
    
}
