//
// Created by Bogdan Sasko on 1/28/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

class SubscriptionsInteractor {
    weak var output: SubscriptionsInteractorOutput!
    var CHSubscriptionPackage: CHSubscriptionPackageProtocol?
    
    static func buildSubcsriptionCells(priceForLite strPriceLite: String, priceForPro strPricePro: String) -> [SubscriptionsCellModel] {
        return [
            SubscriptionsCellModel(name: "Max Alerts", forFree: 0, forLite: 10, forPro: 25, activeSubscriptionType: IAPService.shared.CHSubscriptionPackage.type),
            SubscriptionsCellModel(name: "Watchlist Max Pairs", forFree: 5, forLite: 10, forPro: 50, activeSubscriptionType: IAPService.shared.CHSubscriptionPackage.type),
            SubscriptionsCellModel(name: "Advertisement", forFree: true, forLite: false, forPro: false, activeSubscriptionType: IAPService.shared.CHSubscriptionPackage.type),
            SubscriptionsCellModel(name: "Free upcoming features", forFree: false, forLite: false, forPro: true, activeSubscriptionType: IAPService.shared.CHSubscriptionPackage.type),
            SubscriptionsCellModel(name: "Support", forFree: true, forLite: true, forPro: true, activeSubscriptionType: IAPService.shared.CHSubscriptionPackage.type),
            SubscriptionsCellModel(name: "Price/month", forFree: false, forLite: strPriceLite, forPro: false, activeSubscriptionType: IAPService.shared.CHSubscriptionPackage.type),
            SubscriptionsCellModel(name: "Price/year", forFree: false, forLite: false, forPro: strPricePro, activeSubscriptionType: IAPService.shared.CHSubscriptionPackage.type)
        ]
    }
}

// MARK: SubscriptionsInteractorInput
extension SubscriptionsInteractor: SubscriptionsInteractorInput {
    func viewDidLoad() {
        subscribeOnIAPNotifications()
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
        unsubscribeFromNotifications()
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
}

extension SubscriptionsInteractor {
    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let newSubscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? CHSubscriptionPackageProtocol else {
            print("\(#function) => can't convert notification container to CHSubscriptionPackageProtocol")
            output.purchaseFinishedSuccess()
            return
        }
        
        if let CHSubscriptionPackage = self.CHSubscriptionPackage {
            if newSubscriptionPackage.type == CHSubscriptionPackage.type  {
                output.purchaseFinishedSuccess()
                return
            }
        }
        
        self.CHSubscriptionPackage = newSubscriptionPackage
        output.onPurchaseSubscriptionSuccess(newSubscriptionPackage)
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
