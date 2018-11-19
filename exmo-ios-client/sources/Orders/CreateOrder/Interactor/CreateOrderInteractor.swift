//
//  CreateOrderCreateOrderInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation

class CreateOrderInteractor {
    weak var output: CreateOrderInteractorOutput!
    var networkWorker: ITickerNetworkWorker!
    var timerScheduler: Timer?
    
    private var currencyPairCode: String = ""
    
//    deinit {
//        // LoadCurrencySettingsSuccess
//    }
    
//    @objc func onLoadCurrencySettingsSuccess(notification: Notification) {
//        guard let orderSettings = notification.userInfo?["data"] as? OrderSettings else {
//            return
//        }
//        output.setOrderSettings(orderSettings: orderSettings)
//    }
    
    private func scheduleUpdateCurrencies() {
        timerScheduler = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {
            [weak self] _ in
            self?.networkWorker.loadTicker()
        }
    }
    
    private func stopScheduleUpdateCurrencies() {
        if timerScheduler != nil {
            timerScheduler?.invalidate()
            timerScheduler = nil
        }
    }
}


extension CreateOrderInteractor: CreateOrderInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
    }
    
    func viewWillDisappear() {
        currencyPairCode = ""
        stopScheduleUpdateCurrencies()
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
    
    func handleSelectedCurrency(rawName: String) {
        currencyPairCode = rawName
        scheduleUpdateCurrencies()
        networkWorker.loadTicker()
    }
}

extension CreateOrderInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        print("onDidLoadTickerSuccess")
        if currencyPairCode.isEmpty {
            return
        }
        
        guard let ticker = ticker,
              let currencyPairModel = ticker.pairs[currencyPairCode] else { return }
        self.output.updateSelectedCurrency(currencyPairModel)
    }
    
    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("onDidLoadTickerFails")
        self.output.updateSelectedCurrency(nil)
    }
}
