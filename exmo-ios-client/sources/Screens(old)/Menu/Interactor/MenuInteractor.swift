////
////  MoreMenuInteractor.swift
////  ExmoMobileClient
////
////  Created by TQ0oS on 27/02/2018.
////  Copyright © 2018 Roobik. All rights reserved.
////
//import Foundation
//import UIKit
//
//class MenuInteractor: MenuInteractorInput {
//    weak var output: MenuInteractorOutput!
//    var dbManager: OperationsDatabaseProtocol!
//    
//    deinit {
//        unsubscribeFromNotifications()
//    }
//}
//
//// MARK: MenuInteractorInput
//extension MenuInteractor {
//    func viewIsReady() {
//        subscribeOnEvents()
//        subscribeOnIAPNotifications()
//
//        if Defaults.isUserLoggedIn() {
//            onUserSignIn()
//        } else {
//            onUserSignOut()
//        }
//    }
//
//    func logout() {
//        ExmoApiRequestsBuilder.shared.clearAuthorizationData()
//        Defaults.setUserLoggedIn(false)
//        dbManager.clearAllData()
//        NotificationCenter.default.post(name: .UserSignOut)
//    }
//}
//
//// MARK: MenuInteractorInput
//extension MenuInteractor {
//    private func subscribeOnEvents() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.onUserSignIn), name: .UserSignIn)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.onUserSignOut), name: .UserSignOut)
//    }
//    
//    @objc func onUserSignIn() {
//        output.onUserLogInOut(isLoggedUser: true)
//    }
//
//    @objc func onUserSignOut() {
//        output.onUserLogInOut(isLoggedUser: false)
//    }
//}
//
//extension MenuInteractor {
//    func subscribeOnIAPNotifications() {
//        NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(onProductSubscriptionActive(_ :)),
//                name: IAPNotification.updateSubscription.name)
//        NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(onPurchaseError(_ :)),
//                name: IAPNotification.purchaseError.name)
//    }
//
//    func unsubscribeFromNotifications() {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
//extension MenuInteractor {
//    @objc
//    func onProductSubscriptionActive(_ notification: Notification) {
//        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
//        guard let CHSubscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? CHSubscriptionPackageProtocol else {
//            print("\(#function) => can't convert notification container to IAPProduct")
//            output.setIsAdsPresent(true)
//            return
//        }
//        output.setIsAdsPresent(CHSubscriptionPackage.isAdsPresent)
//    }
//
//    @objc
//    func onPurchaseError(_ notification: Notification) {
//       print("\(String(describing: self)), \(#function) => notification \(notification.name)")
//        guard let _ = notification.userInfo?[IAPService.kErrorKey] as? String else {
//            print("\(#function) => can't cast error message to String")
//            output.setIsAdsPresent(true)
//            return
//        }
//        output.setIsAdsPresent(true)
//    }
//}
