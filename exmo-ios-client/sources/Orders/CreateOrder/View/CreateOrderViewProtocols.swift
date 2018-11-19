//
//  CreateOrderCreateOrderViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateOrderViewInput: class {
    func setupInitialState()
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?)
    func setOrderSettings(orderSettings: OrderSettings)
}

protocol CreateOrderViewOutput: class {
    func viewIsReady()
    func viewWillDisappear()
    func onTabChanged()
    func createOrder(orderModel: OrderModel)
    func handleTouchOnCancelButton()
    func openCurrencySearchVC()
}
