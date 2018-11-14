//
//  CreateOrderCreateOrderViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateOrderViewInput: class {
    func setupInitialState()
    func updateSelectedCurrency(name: String, price: Double)
    func setOrderSettings(orderSettings: OrderSettings)
    func showPickerView()
}

protocol CreateOrderViewOutput {
    func viewIsReady()
    func createOrder(orderModel: OrderModel)
    func handleTouchOnCancelButton()
    func openCurrencySearchView(data: [SearchModel])
    func handleTouchOnOrderType()
}
