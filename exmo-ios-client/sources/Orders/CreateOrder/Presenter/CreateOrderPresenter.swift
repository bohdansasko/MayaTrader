//
//  CreateOrderCreateOrderPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class CreateOrderPresenter: CreateOrderModuleInput, CreateOrderViewOutput, CreateOrderInteractorOutput {
    weak var view: CreateOrderViewInput!
    var interactor: CreateOrderInteractorInput!
    var router: CreateOrderRouterInput!

    func viewIsReady() {

    }
    
    func createOrder(orderModel: ActiveOrderModel) {
        interactor.createOrder(orderModel: orderModel)
    }
}
