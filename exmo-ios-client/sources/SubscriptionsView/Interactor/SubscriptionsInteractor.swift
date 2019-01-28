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
