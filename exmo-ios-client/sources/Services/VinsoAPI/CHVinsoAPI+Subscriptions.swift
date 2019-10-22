//
//  VinsoAPI+Subscriptions.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

// MARK: - Manage subscriptions like set, fetch, ..., etc

extension VinsoAPI {
    
    func setSubscription(_ packageType: CHSubscriptionPackageType) {
        let params: [String: Any] = ["type": packageType.rawValue]
        
        self.sendRequest(messageType: .setSubscriptionType, params: params)
            .asSingle()
            .subscribe(onSuccess: { [weak self] json in
                guard let `self` = self else { return }
                switch packageType {
                case .freeWithAds:
                    self.subscriptionPackage = CHBasicAdsSubscriptionPackage()
                case .freeNoAds:
                    self.subscriptionPackage = CHBasicNoAdsSubscriptionPackage()
                case .lite:
                    self.subscriptionPackage = CHLiteSubscriptionPackage()
                case .pro:
                    self.subscriptionPackage = CHProSubscriptionPackage()
                }
                NotificationCenter.default.post(name: IAPNotification.updateSubscription)
            }, onError: { err in
                log.error(err)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchAvailableSubscriptions() {
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

// MARK: - Manage notification subscribes

extension VinsoAPI {
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
