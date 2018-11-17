//
//  CreateOrderCreateOrderInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol CreateOrderInteractorInput {
    func createOrder(orderModel: OrderModel)
    func handleSelectedCurrency(rawName: String)
}

protocol CreateOrderInteractorOutput: class {
    func updateSelectedCurrency(name: String, price: Double)
    func closeView()
    func setOrderSettings(orderSettings: OrderSettings)
}
