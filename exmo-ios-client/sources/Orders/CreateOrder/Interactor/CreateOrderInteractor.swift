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
    private var currencyPairCode: String = ""
}

// MARK: CreateOrderInteractorInput
extension CreateOrderInteractor: CreateOrderInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
        ordersNetworkWorker.delegate = self
    }
    
    func viewWillDisappear() {
        currencyPairCode = ""
        networkWorker.cancelRepeatLoads()
    }
    
    func createOrder(orderModel: OrderModel) {
        print(orderModel)
        networkWorker.cancelRepeatLoads()
        ordersNetworkWorker.createOrder(order: orderModel)
    }
    
    func handleSelectedCurrency(rawName: String) {
        currencyPairCode = rawName
        networkWorker.load(timeout: FrequencyUpdateInSec.createOrder, repeat: true)
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
    
    func onDidLoadTickerFails() {
        print("onDidLoadTickerFails")
        networkWorker.cancelRepeatLoads()
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
        networkWorker.load(timeout: FrequencyUpdateInSec.createOrder, repeat: true)
        output.showAlert(message: errorMessage)
    }
}
