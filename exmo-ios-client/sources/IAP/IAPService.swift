//
//  IAPService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/5/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation
import StoreKit

class IAPService: NSObject {
    private override init() { /* do nothing */ }
    static let shared = IAPService()
    
    var products = [SKProduct]()
    var paymentQueue = SKPaymentQueue.default()
    
    func loadProducts() {
        let products: Set = [IAPProduct.LightApp.rawValue,
                             IAPProduct.ProApp.rawValue,
                             IAPProduct.Advertisements.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else {
            return
        }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        print("response.products.count = \(response.products.count)")
        response.invalidProductIdentifiers.forEach({ print($0) })
        response.products.forEach({ print($0.localizedTitle) })
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            print($0.transactionState)
            print($0.transactionState.getState(), $0.payment.productIdentifier)
        })
    }
}

extension SKPaymentTransactionState {
    func getState() -> String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchasing: return "purchasing"
        case .purchased: return "purchased"
        case .restored: return "restored"
        }
    }
}
