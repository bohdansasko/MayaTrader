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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onProductSubscriptionActive(_ :)),
            name: IAPNotification.updateSubscription)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPurchaseError(_ :)),
            name: IAPNotification.purchaseError)
    }
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setSubscriptionType(_ packageType: CHSubscriptionPackageType) {
        self.sendRequest(messageType: .setSubscriptionType, params: ["type": packageType.rawValue])
            .asSingle()
            .subscribe(onSuccess: { json in
                log.debug(json)
            }, onError: { err in
                log.error(err)
            })
            .disposed(by: disposeBag)
    }
    
    func loadAvailableSubscriptions() {
        self.sendRequest(messageType: .subscriptionConfigs)
            .asSingle()
            .subscribe(onSuccess: { json in
                log.debug(json)
            }, onError: { err in
                log.error(err)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Notification handlers

private extension VinsoAPI {

    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        log.info("notification name =", notification.name)
        guard let CHSubscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? CHSubscriptionPackageProtocol else {
            log.info("can't convert notification container to IAPProduct")
            if AppDelegate.vinsoAPI.isAuthorized {
                AppDelegate.vinsoAPI.setSubscriptionType(.freeWithAds)
            }
            return
        }
        
        if AppDelegate.vinsoAPI.isAuthorized {
            AppDelegate.vinsoAPI.setSubscriptionType(CHSubscriptionPackage.type)
        }
    }
    
    @objc
    func onPurchaseError(_ notification: Notification) {
        if AppDelegate.vinsoAPI.isAuthorized {
            AppDelegate.vinsoAPI.setSubscriptionType(.freeWithAds)
        }
    }
    
}
