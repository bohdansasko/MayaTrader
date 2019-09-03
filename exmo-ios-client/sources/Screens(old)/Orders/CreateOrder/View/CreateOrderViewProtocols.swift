//
//  CreateOrderCreateOrderViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateOrderViewInput: class {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?)
    func setOrderSettings(orderSettings: OrderSettings)
    func onCreateOrderSuccessull()
    func showAlert(message: String)
}

protocol CreateOrderViewOutput: class {
    func viewDidLoad()
    func viewWillDisappear()
    func onTabChanged()
    func createOrder(orderModel: OrderModel)
    func handleTouchOnCancelButton()
    func openCurrencySearchVC()
}
