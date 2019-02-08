//
// Created by Bogdan Sasko on 1/28/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

class SubscriptionsInteractor {
    weak var output: SubscriptionsInteractorOutput!
    
    static func buildSubcsriptionCells(priceForLite strPriceLite: String, priceForPro strPricePro: String) -> [SubscriptionsCellModel] {
        return [
            SubscriptionsCellModel(name: "Max Alerts", forFree: 0, forLite: 10, forPro: 25, activeSubscriptionType: IAPService.shared.subscriptionPackage.type),
            SubscriptionsCellModel(name: "Watchlist Max Pairs", forFree: 5, forLite: 10, forPro: 50, activeSubscriptionType: IAPService.shared.subscriptionPackage.type),
            SubscriptionsCellModel(name: "Advertisement", forFree: true, forLite: false, forPro: false, activeSubscriptionType: IAPService.shared.subscriptionPackage.type),
            SubscriptionsCellModel(name: "Free upcoming features", forFree: false, forLite: false, forPro: true, activeSubscriptionType: IAPService.shared.subscriptionPackage.type),
            SubscriptionsCellModel(name: "Support", forFree: true, forLite: true, forPro: true, activeSubscriptionType: IAPService.shared.subscriptionPackage.type),
            SubscriptionsCellModel(name: "Price/month", forFree: false, forLite: strPriceLite, forPro: false, activeSubscriptionType: IAPService.shared.subscriptionPackage.type),
            SubscriptionsCellModel(name: "Price/year", forFree: false, forLite: false, forPro: strPricePro, activeSubscriptionType: IAPService.shared.subscriptionPackage.type)
        ]
    }
}

// MARK: SubscriptionsInteractorInput
extension SubscriptionsInteractor: SubscriptionsInteractorInput {
    func viewDidLoad() {
        subscribeOnIAPEvents()
    }
    
    func fetchSubscriptions() {
        IAPService.shared.fetchProducts(completionOnSuccess: {
            [weak self] products in
            var priceForLite: String = "$0.99"
            var priceForPro: String = "$9.99"
            
            products.forEach({
                switch $0.productIdentifier {
                case IAPProduct.litePackage.rawValue: priceForLite = $0.localizedPrice ?? "$0.99"
                case IAPProduct.proPackage.rawValue: priceForPro = $0.localizedPrice ?? "$9.99"
                default: break
                }
            })
            
            let items = SubscriptionsInteractor.buildSubcsriptionCells(priceForLite: priceForLite, priceForPro: priceForPro)
            self?.output.setSubscriptionItems(with: items)
        }, completionOnError: {
            [weak self] msg in
            self?.output.showError(msg: msg ?? "Fetch subscriptions: undefined error")
        })
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
        fetchSubscriptions()
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
