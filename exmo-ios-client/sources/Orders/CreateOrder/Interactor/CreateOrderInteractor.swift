//
//  CreateOrderCreateOrderInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation

class CreateOrderInteractor: CreateOrderInteractorInput {

    weak var output: CreateOrderInteractorOutput!

    private var data: [SearchCurrencyPairModel]
    private var currencyId: Int = -1

    init() {
        self.data = AppDelegate.session.getSearchCurrenciesContainer()
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onLoadTickers), name: .LoadTickerSuccess)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onLoadCurrencySettingsSuccess), name: .LoadCurrencySettingsSuccess)
    }

    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }

    @objc func onLoadTickers() {
        self.data = AppDelegate.session.getSearchCurrenciesContainer()
    }
    
    @objc func onLoadCurrencySettingsSuccess(notification: Notification) {
        guard let orderSettings = notification.userInfo?["data"] as? OrderSettings else {
            return
        }
        output.setOrderSettings(orderSettings: orderSettings)
    }

    func createOrder(orderModel: OrderModel) {
        let (isSuccess, orderId) = AppDelegate.session.createOrder(order: orderModel)
        if isSuccess {
            var newOrderModel = orderModel
                newOrderModel.setOrderId(id: orderId)
            AppDelegate.session.appendOrder(orderModel: newOrderModel)
        }
        self.output.closeView()
    }
    
    func handleSelectedCurrency(currencyId: Int) {
        self.currencyId = currencyId
        guard let currencyData = self.data.first(where: {$0.id == currencyId}) else {
            return
        }
        AppDelegate.session.loadCurrencyPairSettings(currencyData.getName())
        self.output.updateSelectedCurrency(name: currencyData.getDisplayName(), price: currencyData.price)
    }
}
