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

// MARK: CreateOrderViewOutput
extension CreateOrderPresenter: CreateOrderViewOutput {
    func viewDidLoad() {
        interactor.viewDidLoad()
    }
    
    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }
    
    func onTabChanged() {
        interactor.updateSelectedCurrency()
    }

    func createOrder(orderModel: OrderModel) {
        interactor.createOrder(orderModel: orderModel)
    }

    func handleTouchOnCancelButton() {
        if let viewController = view as? UIViewController {
            router.closeView(view: viewController)
        }
    }

    func openCurrencySearchVC() {
        if let viewController = view as? UIViewController {
            router.openCurrencySearchVC(viewController, moduleOutput: self)
        }
    }
}

// MARK: CreateOrderInteractorOutput
extension CreateOrderPresenter: CreateOrderInteractorOutput {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?) {
        view.updateSelectedCurrency(tickerCurrencyPair)
    }

    func closeView() {
        handleTouchOnCancelButton()
    }

    func setOrderSettings(orderSettings: OrderSettings) {
        view.setOrderSettings(orderSettings: orderSettings)
    }
    
    func onCreateOrderSuccessull() {
        view.onCreateOrderSuccessull()
    }
    
    func showAlert(message: String) {
        view.showAlert(message: message)
    }
}

// MARK: CreateOrderInteractorOutput
extension CreateOrderPresenter: SearchModuleOutput {
    func onDidSelectCurrencyPair(rawName: String) {
        log.debug("was selected currency with id = \(rawName)")
        interactor.handleSelectedCurrency(rawName: rawName)
    }
}
