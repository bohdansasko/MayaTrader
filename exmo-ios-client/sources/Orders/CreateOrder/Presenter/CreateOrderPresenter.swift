//
//  CreateOrderCreateOrderPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UIViewController

class CreateOrderPresenter: CreateOrderModuleInput, CreateOrderViewOutput, CreateOrderInteractorOutput {
    weak var view: CreateOrderViewInput!
    var interactor: CreateOrderInteractorInput!
    var router: CreateOrderRouterInput!

    func viewIsReady() {
        // do nothing
    }
    
    func createOrder(orderModel: OrderModel) {
        interactor.createOrder(orderModel: orderModel)
    }
    
    func handleTouchOnCancelButton() {
        router.closeView(view: view as! UIViewController)
    }
}
