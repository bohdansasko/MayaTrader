//
// Created by Bogdan Sasko on 1/28/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol SubscriptionsViewInput: class {
    func showAlert(msg: String)
    func updateTable(with items: [SubscriptionsCellModel])
    func hideLoaderActivity()
}

protocol SubscriptionsViewOutput {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()

    func onTouchButtonBuyLitePackage()
    func onTouchButtonBuyProPackage()
    func onTouchButtonRestorePurchases()
    func onTouchButtonClose()
}
