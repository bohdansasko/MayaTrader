//
// Created by Bogdan Sasko on 1/28/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class SubscriptionsPresenter {
    weak var view: SubscriptionsViewInput!
    var router: SubscriptionsRouterInput!
    var interactor: SubscriptionsInteractorInput!
}

extension SubscriptionsPresenter: SubscriptionsViewOutput {
    func onTouchButtonBuyLitePackage() {
        interactor.buyLitePackage()
    }

    func onTouchButtonBuyProPackage() {
        interactor.buyProPackage()
    }

    func onTouchButtonRestorePurchases() {
        interactor.restorePurchases()
    }

    func onTouchCloseButton() {
        router.closeView(view as! UIViewController)
    }
}

extension SubscriptionsPresenter: SubscriptionsInteractorOutput {
    // do nothing
}