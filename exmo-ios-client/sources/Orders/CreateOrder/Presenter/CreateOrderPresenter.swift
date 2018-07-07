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
    
    func openCurrencySearchView(data: [SearchModel]) {
        router.openCurrencySearchView(data: data, view: view as! UIViewController, callbackOnSelectCurrency: {
            (currencyId) in
            print("was selected currency with id = \(currencyId)")
            self.interactor.handleSelectedCurrency(currencyId: currencyId)
        })
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        self.view.updateSelectedCurrency(name: name, price: price)
    }
}
