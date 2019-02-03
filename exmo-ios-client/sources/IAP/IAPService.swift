//
//  IAPService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/5/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import StoreKit
import SwiftyStoreKit

class IAPService: NSObject {
    enum Notification: String, NotificationName {
        case completeTransaction
        
        case purchaseSuccess
        case purchaseError
        
        case purchased
        case expired
        case notPurchased

        case updateSubscription
    }

    static let shared = IAPService()
    override private init() {
        super.init()
        loadSubscriptionFromCache()
    }
    
    private let kSharedSecret = "d2d81af55e2f43e3a690af0b28999356"
    private let kReceiptSubscriptionURLType = AppleReceiptValidator.VerifyReceiptURLType.sandbox
    private(set) var purchasedSubscriptions: [ReceiptItem] = []
    private(set) var subscriptionPackage: ISubscriptionPackage! {
        didSet {
            print("\(#function) - Active subscription: \(subscriptionPackage.name)")
            Defaults.setSubscriptionId(subscriptionPackage.type.rawValue)
        }
    }

    static let kSubscriptionPackageKey = "subscriptionPackage"
    static let kErrorKey = "error"
    
    func loadSubscriptionFromCache() {
        guard let subscriptionType = SubscriptionPackageType(rawValue: Defaults.getSubscriptionId()) else {
            subscriptionPackage = BasicAdsSubscriptionPackage()
            return
        }
        
        switch subscriptionType {
        case .freeWithAds: subscriptionPackage = BasicAdsSubscriptionPackage()
        case .freeNoAds: subscriptionPackage = BasicNoAdsSubscriptionPackage()
        case .lite: subscriptionPackage = LiteSubscriptionPackage()
        case .pro: subscriptionPackage = ProSubscriptionPackage()
        }
    }
}

extension IAPService {
    func fetchAllSubscriptions() {
        purchasedSubscriptions = []
        print("\(String(describing: self)), \(#function)")
        let appleValidator = AppleReceiptValidator(service: kReceiptSubscriptionURLType, sharedSecret: kSharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIds = Set<String>(IAPProduct.allCases.map({ $0.rawValue }))
                
                // Verify the purchase of a subscriptions
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(_, let items):
                    let currentDate = Date()
                    let activeSubscriptions = items.filter({
                        receipt in
                        guard let subscriptionExpirationDate = receipt.subscriptionExpirationDate else {
                            return false
                        }
                        return currentDate < subscriptionExpirationDate
                    })

                    if activeSubscriptions.contains(where: { $0.productId == IAPProduct.proPackage.rawValue }) {
                        self.updateSubscription(ProSubscriptionPackage())
                    } else if activeSubscriptions.contains(where: { $0.productId == IAPProduct.litePackage.rawValue }) {
                        self.updateSubscription(LiteSubscriptionPackage())
                    } else if activeSubscriptions.contains(where: { $0.productId == IAPProduct.noAds.rawValue }) {
                        self.updateSubscription(BasicNoAdsSubscriptionPackage())
                    } else {
                        self.updateSubscription(BasicAdsSubscriptionPackage())
                    }
                    print("\(#function) => purchased items => \(activeSubscriptions) \n\n")
                case .expired(_, _), .notPurchased:
                    print("\(#function) => updateSubscription \n\n")
                    self.updateSubscription(BasicAdsSubscriptionPackage())
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
                self.updateSubscription(BasicAdsSubscriptionPackage())
                self.sendNotification(.purchaseError, data: [IAPService.kErrorKey: error.localizedDescription])
            }
        }
    }

    func isProductPurchased(_ product: IAPProduct) -> Bool {
        let nowDatetime = Date()
        return purchasedSubscriptions.contains(where: {
            receipt in
            guard let subscriptionExpirationDate = receipt.subscriptionExpirationDate else {
                return false
            }
            let isDateOk = nowDatetime < subscriptionExpirationDate
            print("\(#function) => productId = \(receipt.productId), subscriptionExpirationDate = \(subscriptionExpirationDate), isDateOk = \(isDateOk)")

            return receipt.productId == product.rawValue && isDateOk
        })
    }

    func fetchProducts() {
        let products = Set<String>(IAPProduct.allCases.map({ $0.rawValue }))
        SwiftyStoreKit.retrieveProductsInfo(products) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(result.error)")
            }
        }
    }

    func completeTransactions() {
        // see notes below for the meaning of Atomic / Non-Atomic
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
            self.sendNotification(.completeTransaction, data: [:])
        }
    }

    func purchase(product: IAPProduct) {
        SwiftyStoreKit.purchaseProduct(product.rawValue, quantity: 1, atomically: true) { result in
            let notificationData = [IAPService.kSubscriptionPackageKey: product]
            switch result {
            case .success(let purchase):
                self.sendNotification(.purchaseSuccess, data: notificationData)
                print("Purchase Success: \(purchase.productId)")
                guard let purchasedProduct = IAPProduct(rawValue: purchase.productId) else {
                    self.updateSubscription(BasicAdsSubscriptionPackage())
                    return
                }

                var subscriptionPackage: ISubscriptionPackage
                switch purchasedProduct {
                case IAPProduct.proPackage: subscriptionPackage = ProSubscriptionPackage()
                case IAPProduct.litePackage: subscriptionPackage = LiteSubscriptionPackage()
                case IAPProduct.noAds: subscriptionPackage = BasicNoAdsSubscriptionPackage()
                }
                self.updateSubscription(subscriptionPackage)

            case .error(let error):
                var errorMessage: String
                switch error.code {
                case .unknown: errorMessage = "Unknown error. Please contact support"
                case .clientInvalid: errorMessage = "Not allowed to make the payment"
                case .paymentCancelled: errorMessage = "Payment has cancelled"
                case .paymentInvalid: errorMessage = "The purchase identifier was invalid"
                case .paymentNotAllowed: errorMessage = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: errorMessage = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: errorMessage = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: errorMessage = "Could not connect to the network"
                case .cloudServiceRevoked: errorMessage = "User has revoked permission to use this cloud service"
                default: errorMessage = (error as NSError).localizedDescription
                }

                self.updateSubscription(BasicAdsSubscriptionPackage())
                self.sendNotification(.purchaseError, data: [IAPService.kErrorKey: errorMessage])
            }
        }
    }

    func restorePurchases() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.updateSubscription(BasicAdsSubscriptionPackage())
            } else if results.restoredPurchases.count > 0 {
                let isProPackage = results.restoredPurchases.contains(where: { $0.productId == IAPProduct.proPackage.rawValue })
                let isLitePackage = results.restoredPurchases.contains(where: { $0.productId == IAPProduct.litePackage.rawValue })
                let isNoAdsPackage = results.restoredPurchases.contains(where: { $0.productId == IAPProduct.noAds.rawValue })
                
                var purchasedProduct: ISubscriptionPackage = BasicAdsSubscriptionPackage()
                if isProPackage {
                    purchasedProduct = ProSubscriptionPackage()
                } else if isLitePackage {
                    purchasedProduct = LiteSubscriptionPackage()
                } else if isNoAdsPackage {
                    purchasedProduct = BasicNoAdsSubscriptionPackage()
                }
                self.updateSubscription(purchasedProduct)
            } else {
                print("Nothing to Restore")
                self.updateSubscription(BasicAdsSubscriptionPackage())
            }
        }
    }

    func verifySubscription(_ product: IAPProduct, subscriptionType: SubscriptionType = .autoRenewable) {
        let appleValidator = AppleReceiptValidator(service: kReceiptSubscriptionURLType, sharedSecret: kSharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = product.rawValue
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: subscriptionType,
                        productId: productId,
                        inReceipt: receipt)

                let notificationData = [IAPService.kSubscriptionPackageKey: product]
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    if let item = items.first {
                        self.purchasedSubscriptions.append(item)
                    }
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    self.sendNotification(.purchased, data: notificationData)

                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items.first)\n")
                    self.sendNotification(.expired, data: notificationData)

                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    self.sendNotification(.notPurchased, data: notificationData)
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }

    func verifySubscriptions() {
        let appleValidator = AppleReceiptValidator(service: kReceiptSubscriptionURLType, sharedSecret: kSharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIds = Set(IAPProduct.allCases.map({ $0.rawValue }))
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productIds)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }

    private func sendNotification(_ notificationType: IAPService.Notification, data: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            AppDelegate.notificationController.postBroadcastMessage(name: notificationType.name, data: data)
        }
    }

    private func updateSubscription(_ subscriptionPackage: ISubscriptionPackage) {
        self.subscriptionPackage = subscriptionPackage
        self.sendNotification(.updateSubscription, data: [IAPService.kSubscriptionPackageKey: subscriptionPackage])
    }
}
