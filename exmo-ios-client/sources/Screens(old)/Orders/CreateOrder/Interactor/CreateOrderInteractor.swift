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
    var viewIsReady = false
    var selectedPair: TickerCurrencyModel?
}

// MARK: CreateOrderInteractorInput
extension CreateOrderInteractor: CreateOrderInteractorInput {
    func viewDidLoad() {
        networkWorker.delegate = self
        ordersNetworkWorker.delegate = self
        viewIsReady = true
        handleSelectedCurrency(rawName: currencyPairCode)
    }
    
    func viewWillDisappear() {
        networkWorker.cancelRepeatLoads()
    }
    
    func updateSelectedCurrency() {
        output.updateSelectedCurrency(selectedPair)
    }
    
    func createOrder(orderModel: OrderModel) {
        log.debug(orderModel)
        networkWorker.cancelRepeatLoads()
        ordersNetworkWorker.createOrder(order: orderModel)
    }
    
    func handleSelectedCurrency(rawName: String) {
        if rawName.isEmpty { return }

        currencyPairCode = rawName

        if !viewIsReady { return }

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
        selectedPair = currencyPairModel
        output.updateSelectedCurrency(selectedPair)
    }
    
    func onDidLoadTickerFails() {
        log.error("onDidLoadTickerFails")
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
        log.error(errorMessage)
        networkWorker.load(timeout: FrequencyUpdateInSec.createOrder, repeat: true)
        output.showAlert(message: errorMessage)
    }
}
