//
//  OrdersViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol OrdersViewInput: class {
    func showPlaceholderNoData()
    func removePlaceholderNoData()
    
    func updateOrders(loadedOrders: [Orders.DisplayType : Orders])
}

protocol OrdersViewOutput {
    func viewIsReady()
}
