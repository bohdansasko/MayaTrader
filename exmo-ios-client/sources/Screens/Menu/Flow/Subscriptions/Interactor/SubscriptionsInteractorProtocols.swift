//
// Created by Bogdan Sasko on 1/28/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol SubscriptionsInteractorInput {
    func viewDidLoad()
    func viewWillDisappear()

    func fetchSubscriptions()
    
    func buyLitePackage()
    func buyProPackage()
    func restorePurchases()
}

protocol SubscriptionsInteractorOutput: class {
    func onPurchaseSubscriptionSuccess(_ CHSubscriptionPackage: CHSubscriptionPackageProtocol)
    func onPurchaseSubscriptionError(reason: String)
    func purchaseFinishedSuccess()
    
    func setSubscriptionItems(with items: [SubscriptionsCellModel])
    func showError(msg: String)
}
