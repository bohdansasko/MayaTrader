//
//  IAPService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/5/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import StoreKit
import SwiftyStoreKit

final class IAPService: NSObject {
    
    var timer: Timer?
    
    static let shared = IAPService()
    override private init() {
        super.init()
        loadSubscriptionFromCache()
    }
    
    private let kSharedSecret = "ac548a8468d243caa1d13995a28cb3c5"
    private let kReceiptSubscriptionURLType = IAPService.getReceiptSubscriptionURLType()
    private(set) var purchasedSubscriptions: [ReceiptItem] = []
    private(set) var subscriptionPackage: CHSubscriptionPackageProtocol! {
        didSet {
            log.debug("Active subscription: \(subscriptionPackage.name)")
            Defaults.setSubscriptionId(subscriptionPackage.type.rawValue)
        }
    }

    static let kSubscriptionPackageKey = "CHSubscriptionPackage"
    static let kErrorKey = "error"
    
    
    static func getReceiptSubscriptionURLType() -> AppleReceiptValidator.VerifyReceiptURLType {
        return AppleReceiptValidator.VerifyReceiptURLType.production // TODO: use production for production build for all other should be sandbox
    }
    
    func loadSubscriptionFromCache() {
        guard let subscriptionType = CHSubscriptionPackageType(rawValue: Defaults.getSubscriptionId()) else {
            subscriptionPackage = CHBasicAdsSubscriptionPackage()
            return
        }
        
        switch subscriptionType {
        case .freeWithAds: subscriptionPackage = CHBasicAdsSubscriptionPackage()
        case .freeNoAds  : subscriptionPackage = CHBasicNoAdsSubscriptionPackage()
        case .lite       : subscriptionPackage = CHLiteSubscriptionPackage()
        case .pro        : subscriptionPackage = CHProSubscriptionPackage()
        }
    }
}

extension IAPService {
    
    func fetchAllSubscriptions() {
        purchasedSubscriptions = []

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

                    var subscriptionExpirationDate: Date?
                    
                    if let receipt = activeSubscriptions.first(where: { $0.productId == IAPProduct.proPackage.rawValue }) {
                        subscriptionExpirationDate = receipt.subscriptionExpirationDate
                        self.updateSubscription(CHProSubscriptionPackage())
                    } else if let receipt = activeSubscriptions.first(where: { $0.productId == IAPProduct.litePackage.rawValue }) {
                        subscriptionExpirationDate = receipt.subscriptionExpirationDate
                        self.updateSubscription(CHLiteSubscriptionPackage())
                    } else if let receipt = activeSubscriptions.first(where: { $0.productId == IAPProduct.noAds.rawValue }) {
                        subscriptionExpirationDate = receipt.subscriptionExpirationDate
                        self.updateSubscription(CHBasicNoAdsSubscriptionPackage())
                    } else {
                        self.updateSubscription(CHBasicAdsSubscriptionPackage())
                    }
                    
                    if let expirationDate = subscriptionExpirationDate {
                        if self.timer == nil {
                            log.debug("Time to end subscription: \(expirationDate.timeIntervalSinceNow)")
                            self.timer = Timer.scheduledTimer(withTimeInterval: expirationDate.timeIntervalSinceNow, repeats: false, block: {
                                _ in
                                self.onSubscriptionExpired()
                            })
                        }
                    }
                    log.debug("purchased items => \(activeSubscriptions) \n\n")
                case .expired(_, _), .notPurchased:
                    log.debug("\(#function) => updateSubscription \n\n")
                    self.updateSubscription(CHBasicAdsSubscriptionPackage())
                }
            case .error(let error):
                log.error("Receipt verification failed: \(error)")
                self.updateSubscription(CHBasicAdsSubscriptionPackage())
                self.sendNotification(IAPNotification.purchaseError, data: [IAPService.kErrorKey: error.localizedDescription])
            }
        }
    }
    
    func onSubscriptionExpired() {
        fetchAllSubscriptions()
        if timer != nil {
            timer?.invalidate()
            timer = nil
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
            log.debug("productId = \(receipt.productId), subscriptionExpirationDate = \(subscriptionExpirationDate), isDateOk = \(isDateOk)")

            return receipt.productId == product.rawValue && isDateOk
        })
    }

    func fetchProducts(completionOnSuccess: ((Set<SKProduct>) -> Void)? = nil, completionOnError: ((String?) -> Void)? = nil) {
        let products = Set<String>(IAPProduct.allCases.map({ $0.rawValue }))
        SwiftyStoreKit.retrieveProductsInfo(products) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                log.debug("Product: \(product.localizedDescription), price: \(priceString)")
                completionOnSuccess?(result.retrievedProducts)
            } else if let invalidProductId = result.invalidProductIDs.first {
                log.debug("Invalid product identifier: \(invalidProductId)")
                completionOnError?("Products were changed. Plese, contact with app developer.")
            } else {
                log.error("Error: \(result.error)")
                completionOnError?(result.error?.localizedDescription)
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
            self.sendNotification(IAPNotification.completeTransaction, data: [:])
        }
    }

    func purchase(product: IAPProduct) {
        SwiftyStoreKit.purchaseProduct(product.rawValue, quantity: 1, atomically: true) { result in
            let notificationData = [IAPService.kSubscriptionPackageKey: product]
            switch result {
            case .success(let purchase):
                self.sendNotification(IAPNotification.purchaseSuccess, data: notificationData)
                log.debug("Purchase Success: \(purchase.productId)")
                guard let purchasedProduct = IAPProduct(rawValue: purchase.productId) else {
                    self.updateSubscription(CHBasicAdsSubscriptionPackage())
                    return
                }

                var subscriptionPackage: CHSubscriptionPackageProtocol
                switch purchasedProduct {
                case IAPProduct.proPackage : subscriptionPackage = CHProSubscriptionPackage()
                case IAPProduct.litePackage: subscriptionPackage = CHLiteSubscriptionPackage()
                case IAPProduct.noAds      : subscriptionPackage = CHBasicNoAdsSubscriptionPackage()
                }
                self.updateSubscription(subscriptionPackage)

            case .error(let error):
                var errorMessage: String
                switch error.code {
                case .unknown                            : errorMessage = "Unknown error. Please contact support"
                case .clientInvalid                      : errorMessage = "Not allowed to make the payment"
                case .paymentCancelled                   : errorMessage = "Payment has cancelled"
                case .paymentInvalid                     : errorMessage = "The purchase identifier was invalid"
                case .paymentNotAllowed                  : errorMessage = "The device is not allowed to make the payment"
                case .storeProductNotAvailable           : errorMessage = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied       : errorMessage = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: errorMessage = "Could not connect to the network"
                case .cloudServiceRevoked                : errorMessage = "User has revoked permission to use this cloud service"
                default:
                    errorMessage = (error as NSError).localizedDescription
                }
                self.sendNotification(IAPNotification.purchaseError, data: [IAPService.kErrorKey: errorMessage])
            }
        }
    }

    func restorePurchases() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                log.error("Restore Failed: \(results.restoreFailedPurchases)")
                self.updateSubscription(CHBasicAdsSubscriptionPackage())
            } else if results.restoredPurchases.count > 0 {
                let isProPackage   = results.restoredPurchases.contains(where: { $0.productId == IAPProduct.proPackage.rawValue })
                let isLitePackage  = results.restoredPurchases.contains(where: { $0.productId == IAPProduct.litePackage.rawValue })
                let isNoAdsPackage = results.restoredPurchases.contains(where: { $0.productId == IAPProduct.noAds.rawValue })
                
                var purchasedProduct: CHSubscriptionPackageProtocol = CHBasicAdsSubscriptionPackage()
                if isProPackage {
                    purchasedProduct = CHProSubscriptionPackage()
                } else if isLitePackage {
                    purchasedProduct = CHLiteSubscriptionPackage()
                } else if isNoAdsPackage {
                    purchasedProduct = CHBasicNoAdsSubscriptionPackage()
                }
                self.updateSubscription(purchasedProduct)
            } else {
                log.error("Nothing to Restore")
                self.updateSubscription(CHBasicAdsSubscriptionPackage())
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
                    log.debug("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    self.sendNotification(.purchased, data: notificationData)

                case .expired(let expiryDate, let items):
                    log.debug("\(productId) is expired since \(expiryDate)\n\(items.first)\n")
                    self.sendNotification(.expired, data: notificationData)

                case .notPurchased:
                    log.debug("The user has never purchased \(productId)")
                    self.sendNotification(.notPurchased, data: notificationData)
                }

            case .error(let error):
                log.error("Receipt verification failed: \(error)")
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
                    log.debug("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    log.debug("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    log.debug("The user has never purchased \(productIds)")
                }
            case .error(let error):
                log.error("Receipt verification failed: \(error)")
            }
        }
    }

    private func sendNotification(_ notificationType: IAPNotification, data: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: notificationType.name, object: data)
        }
    }

    private func updateSubscription(_ subscriptionPackage: CHSubscriptionPackageProtocol) {
        self.subscriptionPackage = subscriptionPackage
        self.sendNotification(IAPNotification.updateSubscription, data: [IAPService.kSubscriptionPackageKey: subscriptionPackage])
    }
}

// MARK: - UIApplicationDelegate

extension IAPService: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }

    
}
