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
        // do nothing
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
    func updateSelectedCurrency(name: String, price: Double) {
        self.view.updateSelectedCurrency(name: name, price: price)
    }

    func closeView() {
        self.handleTouchOnCancelButton()
    }

    func setOrderSettings(orderSettings: OrderSettings) {
        self.view.setOrderSettings(orderSettings: orderSettings)
    }

    func handleTouchOnOrderType() {
        view.showPickerView()
    }
}

// @MARK: CreateOrderInteractorOutput
extension CreateOrderPresenter: SearchModuleOutput {
    func onDidSelectCurrencyPair(rawName: String) {
        print("was selected currency with id = \(rawName)")
        interactor.handleSelectedCurrency(rawName: rawName)
    }
}
