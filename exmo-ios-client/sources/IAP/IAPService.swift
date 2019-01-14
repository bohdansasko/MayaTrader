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
    private override init() { /* do nothing */ }
    static let shared = IAPService()

    private let kSharedSecret = "d2d81af55e2f43e3a690af0b28999356"
    private let kReceiptSubscriptionURLType = AppleReceiptValidator.VerifyReceiptURLType.sandbox
    private var purchasedSubscriptions: [ReceiptItem] = []
    static let kProductNotificationKey = "product"
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
                    if let item = items.first {
                        print("purchased item => \(item) \n")
//                        UserDefaults.standard.set(item., forKey: UserDefaultsKeys.iapAdvertisement)
                    }
                case .expired(_, _): break
                case .notPurchased: break
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
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
        SwiftyStoreKit.retrieveProductsInfo(products) { [weak self] result in
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
            let notificationData = [IAPService.kProductNotificationKey: product]
            switch result {
            case .success(let purchase):
                self.sendNotification(.purchaseSuccess, data: notificationData)
                print("Purchase Success: \(purchase.productId)")
            case .error(let error):
                self.sendNotification(.purchaseError, data: notificationData)
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }

    func restorePurchases() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
            } else {
                print("Nothing to Restore")
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

                let notificationData = [IAPService.kProductNotificationKey: product]
                
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

    private func sendNotification(_ notificationType: IAPServiceNotification, data: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            AppDelegate.notificationController.postBroadcastMessage(name: notificationType.name, data: data)
        }
    }
}

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

enum IAPServiceNotification: String, NotificationName {
    case completeTransaction
    
    case purchaseSuccess
    case purchaseError
    
    case purchased
    case expired
    case notPurchased
}
