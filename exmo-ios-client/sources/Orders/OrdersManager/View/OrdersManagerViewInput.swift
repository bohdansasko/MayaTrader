//
//  OrdersManagerOrdersManagerViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol OrdersManagerViewInput: class {

    /**
        @author TQ0oS
        Setup initial state of the view
    */

    func setupInitialState()
    func showPlaceholderNoData()
    func removePlaceholderNoData()
}
