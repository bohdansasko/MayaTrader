//
//  CreateOrderCreateOrderPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UIViewController

class CreateOrderPresenter  {
    weak var view: CreateOrderViewInput!
    var interactor: CreateOrderInteractorInput!
    var router: CreateOrderRouterInput!
}

// @MARK: CreateOrderViewOutput
extension CreateOrderPresenter: CreateOrderViewOutput {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }
    
    func onTabChanged() {
        interactor.viewWillDisappear()
    }

    func createOrder(orderModel: OrderModel) {
        interactor.createOrder(orderModel: orderModel)
    }

    func handleTouchOnCancelButton() {
        router.closeView(view: view as! UIViewController)
    }

    func openCurrencySearchVC() {
        router.openCurrencySearchVC(view as! UIViewController, moduleOutput: self)
    }
}

// @MARK: CreateOrderInteractorOutput
extension CreateOrderPresenter: CreateOrderInteractorOutput {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?) {
        self.view.updateSelectedCurrency(tickerCurrencyPair)
    }

    func closeView() {
        self.handleTouchOnCancelButton()
    }

    func setOrderSettings(orderSettings: OrderSettings) {
        self.view.setOrderSettings(orderSettings: orderSettings)
    }
}

// @MARK: CreateOrderInteractorOutput
extension CreateOrderPresenter: SearchModuleOutput {
    func onDidSelectCurrencyPair(rawName: String) {
        print("was selected currency with id = \(rawName)")
        interactor.handleSelectedCurrency(rawName: rawName)
    }
}
