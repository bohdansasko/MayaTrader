//
// Created by Bogdan Sasko on 1/28/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

class SubscriptionsInteractor {
    weak var output: SubscriptionsInteractorOutput!
}

// MARK: SubscriptionsInteractorInput
extension SubscriptionsInteractor: SubscriptionsInteractorInput {
    func viewDidLoad() {
        subscribeOnIAPEvents()
    }

    func viewWillDisappear() {
        unsubscribeEvents()
    }

    func buyLitePackage() {
        IAPService.shared.purchase(product: .litePackage)
    }

    func buyProPackage() {
        IAPService.shared.purchase(product: .proPackage)
    }

    func restorePurchases() {
        IAPService.shared.restorePurchases()
    }
}

extension SubscriptionsInteractor {
    func subscribeOnIAPEvents() {
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPService.Notification.updateSubscription.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onPurchaseError(_ :)),
                name: IAPService.Notification.purchaseError.name)
    }

    func unsubscribeEvents() {
        AppDelegate.notificationController.removeObserver(self)
    }
}

extension SubscriptionsInteractor {
    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let subscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? ISubscriptionPackage else {
            print("\(#function) => can't convert notification container to ISubscriptionPackage")
            output.onPurchaseSubscriptionError(reason: "Purchase: Undefined error")
            return
        }
        output.onPurchaseSubscriptionSuccess(subscriptionPackage)
    }

    @objc
    func onPurchaseError(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let errorMsg = notification.userInfo?[IAPService.kErrorKey] as? String else {
            print("\(#function) => can't cast error message to String")
            output.onPurchaseSubscriptionError(reason: "Purchase: Undefined error")
            return
        }
        output.onPurchaseSubscriptionError(reason: errorMsg)
    }
}