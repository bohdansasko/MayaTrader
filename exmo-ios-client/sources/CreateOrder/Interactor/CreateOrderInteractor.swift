//
//  CreateOrderCreateOrderInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class CreateOrderInteractor: CreateOrderInteractorInput {

    weak var output: CreateOrderInteractorOutput!

    func createOrder(orderModel: OrderModel) {
        print("func createOrder called")
    }
}
