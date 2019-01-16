//
//  OrdersInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol OrdersInteractorInput {
    func viewIsReady()
    func viewWillAppear()
    func loadOrderByType(_ orderType: Orders.DisplayType)
    func cancelOrder(ids: [Int64])
}

protocol OrdersInteractorOutput: class {
    func onDidLoadOrders(loadedOrders: [Orders.DisplayType : Orders])
    func orderCanceled(ids: [Int64])
    func setSubscription(_ package: ISubscriptionPackage)
}
