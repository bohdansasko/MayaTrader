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
    func viewDidLoad() {
        interactor.viewDidLoad()
    }
    
    func viewWillAppear() {
        interactor.fetchSubscriptions()
    }

    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }

    func onTouchButtonBuyLitePackage() {
        interactor.buyLitePackage()
    }

    func onTouchButtonBuyProPackage() {
        interactor.buyProPackage()
    }

    func onTouchButtonRestorePurchases() {
        interactor.restorePurchases()
    }

    func onTouchButtonClose() {
        router.closeView(view as! UIViewController)
    }
}

extension SubscriptionsPresenter: SubscriptionsInteractorOutput {
    func onPurchaseSubscriptionSuccess(_ subscriptionPackage: ISubscriptionPackage) {
        view.showAlert(msg: "Congratulations! From now you have \(subscriptionPackage.name) subscription. Enjoy using our app :)")
    }

    func onPurchaseSubscriptionError(reason: String) {
        view.showAlert(msg: reason)
    }
    
    func setSubscriptionItems(with items: [SubscriptionsCellModel]) {
        view.updateTable(with: items)
    }
    
    func showError(msg: String) {
        view.showAlert(msg: msg)
    }
    
    func purchaseFinishedSuccess() {
        view.hideLoaderActivity()
    }
}
