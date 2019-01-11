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
    var ordersNetworkWorker: IOrdersNetworkWorker!
    var timerScheduler: Timer?
    
    private var currencyPairCode: String = ""
    
    private func scheduleUpdateCurrencies() {
        timerScheduler = Timer.scheduledTimer(withTimeInterval: FrequencyUpdateInSec.createOrder, repeats: true) {
            [weak self] _ in
            self?.networkWorker.load()
        }
    }
    
    private func unscheduleUpdateCurrencies() {
        if timerScheduler != nil {
            timerScheduler?.invalidate()
            timerScheduler = nil
        }
    }
}

// MARK: CreateOrderInteractorInput
extension CreateOrderInteractor: CreateOrderInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
        ordersNetworkWorker.delegate = self
    }
    
    func viewWillDisappear() {
        currencyPairCode = ""
        unscheduleUpdateCurrencies()
    }
    
    func createOrder(orderModel: OrderModel) {
        print(orderModel)
        unscheduleUpdateCurrencies()
        ordersNetworkWorker.createOrder(order: orderModel)
    }
    
    func handleSelectedCurrency(rawName: String) {
        currencyPairCode = rawName
        scheduleUpdateCurrencies()
        networkWorker.load()
    }
}

// MARK: ITickerNetworkWorkerDelegate
extension CreateOrderInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        guard let ticker = ticker,
              currencyPairCode.isEmpty == false,
              let currencyPairModel = ticker.pairs[currencyPairCode] else {
                output.showAlert(message: "Something went wrong.")
                return
        }
        self.output.updateSelectedCurrency(currencyPairModel)
    }
    
    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("onDidLoadTickerFails")
        output.updateSelectedCurrency(nil)
        output.showAlert(message: "Can't load data. Please try again a little bit later.")
    }
}

// MARK: IOrdersNetworkWorkerDelegate
extension CreateOrderInteractor: IOrdersNetworkWorkerDelegate {
    func onDidCreateOrderSuccess() {
        output.onCreateOrderSuccessull()
    }
    
    func onDidCreateOrderFail(errorMessage: String) {
        print(errorMessage)
        scheduleUpdateCurrencies()
        output.showAlert(message: errorMessage)
    }
}
