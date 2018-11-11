//
//  CreateOrderCreateOrderViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateOrderViewInput: class {

    /**
        @author TQ0oS
        Setup initial state of the view
    */

    func setupInitialState()
    func updateSelectedCurrency(name: String, price: Double)
    func setOrderSettings(orderSettings: OrderSettings)
    func showPickerView()
}

protocol CreateOrderViewOutput {
    
    /**
     @author TQ0oS
     Notify presenter that view is ready
     */
    
    func viewIsReady()
    func createOrder(orderModel: OrderModel)
    func handleTouchOnCancelButton()
    func openCurrencySearchView(data: [SearchModel])
    func handleTouchOnOrderType()
}
