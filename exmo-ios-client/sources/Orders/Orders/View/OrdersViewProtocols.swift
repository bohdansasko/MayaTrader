//
//  OrdersViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol OrdersViewInput: class {
    func updateOrders(loadedOrders: [Orders.DisplayType : Orders])
    func orderCancelled(ids: [Int64])
    
    func setSubscription(_ package: CHSubscriptionPackageProtocol)
    
    func showAlert(msg: String)
}

protocol OrdersViewOutput: class {
    func viewIsReady()
    func viewWillAppear()
    func onDidSelectTab(_ orderTab: Orders.DisplayType)
    func onTouchButtonAddOrder()
    func cancelOrder(ids: [Int64])
}
