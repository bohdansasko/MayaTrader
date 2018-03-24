//
//  CreateOrderCreateOrderViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateOrderViewOutput {

    /**
        @author TQ0oS
        Notify presenter that view is ready
    */

    func viewIsReady()
    func createOrder(orderModel: ActiveOrderModel)
}
