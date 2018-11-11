//
//  OrdersViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol OrdersViewInput: class {
    func setupInitialState()
    func showPlaceholderNoData()
    func removePlaceholderNoData()
}

protocol OrdersViewOutput {
    func viewIsReady()
}
