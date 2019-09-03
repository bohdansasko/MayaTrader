//
//  CreateOrderCreateOrderInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol CreateOrderInteractorInput {
    func viewDidLoad()
    func viewWillDisappear()
    func createOrder(orderModel: OrderModel)
    func handleSelectedCurrency(rawName: String)
    func updateSelectedCurrency()
}

protocol CreateOrderInteractorOutput: class {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?)
    func closeView()
    func setOrderSettings(orderSettings: OrderSettings)
    func onCreateOrderSuccessull()
    func showAlert(message: String)
}
