//
//  CreateAlertCreateAlertInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertInteractor {

    weak var output: CreateAlertInteractorOutput!
    var tickerNetworkWorker: ITickerNetworkWorker!
    private var currencyPairCode: String = ""
}

extension CreateAlertInteractor: CreateAlertInteractorInput {
    func viewIsReady() {
        tickerNetworkWorker.delegate = self
        AppDelegate.vinsoAPI.addAlertsObserver(self)
    }
    
    func viewWillDisappear() {
        currencyPairCode = ""
        tickerNetworkWorker.cancelRepeatLoads()
        AppDelegate.vinsoAPI.removeAlertsObserver(self)
    }
    
    func createAlert(_ alertModel: Alert) {
        print(alertModel)
        tickerNetworkWorker.cancelRepeatLoads()
        AppDelegate.vinsoAPI.createAlert(alert: alertModel)
    }
    
    func updateAlert(_ alertModel: Alert) {
        AppDelegate.vinsoAPI.updateAlert(alertModel)
    }
    
    func handleSelectedCurrency(rawName: String) {
        currencyPairCode = rawName
        tickerNetworkWorker.load(timeout: FrequencyUpdateInSec.createAlert, repeat: true)
    }
}

// MARK: ITickerNetworkWorkerDelegate
extension CreateAlertInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        guard let ticker = ticker,
            currencyPairCode.isEmpty == false,
            let currencyPairModel = ticker.pairs[currencyPairCode] else {
                output.showAlert(message: "Something went wrong.")
                return
        }
        output.updateSelectedCurrency(currencyPairModel)
    }
    
    func onDidLoadTickerFails() {
        print("onDidLoadTickerFails")
        output.updateSelectedCurrency(nil)
        output.showAlert(message: "Can't load data. Please try again a little bit later.")
    }
}

// MARK: IOrdersNetworkWorkerDelegate
extension CreateAlertInteractor: AlertsAPIResponseDelegate {
    func onDidCreateAlertSuccessful() {
        output.onCreateAlertSuccessful()
    }
    
    func onDidCreateAlertFail(errorMessage: String) {
        print(errorMessage)
        tickerNetworkWorker.load(timeout: FrequencyUpdateInSec.createAlert, repeat: true)
        output.showAlert(message: errorMessage)
    }

    func onDidUpdateAlertSuccessful(_ alert: Alert) {
        output.updateAlertDidSuccessful()
    }
}
