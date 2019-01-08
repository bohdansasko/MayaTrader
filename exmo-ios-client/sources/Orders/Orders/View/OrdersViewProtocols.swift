//
//  OrdersViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol OrdersViewInput: class {
    func updateOrders(loadedOrders: [Orders.DisplayType : Orders])
    func orderCanceled(ids: [Int64])
}

protocol OrdersViewOutput: class {
    func viewIsReady()
    func onDidSelectTab(_ orderTab: Orders.DisplayType)
    func onTouchButtonAddOrder()
    func cancelOrder(ids: [Int64])
}
