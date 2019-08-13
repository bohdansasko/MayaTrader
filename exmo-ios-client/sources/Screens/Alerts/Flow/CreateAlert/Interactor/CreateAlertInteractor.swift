//
//  CreateAlertCreateAlertInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import RxSwift

class CreateAlertInteractor {

           weak var output             : CreateAlertInteractorOutput!
                var tickerNetworkWorker: ITickerNetworkWorker!
    fileprivate var currencyPairCode   : String = ""
    fileprivate var disposeBag         = DisposeBag()
}

extension CreateAlertInteractor: CreateAlertInteractorInput {
    func viewIsReady() {
        tickerNetworkWorker.delegate = self
        AppDelegate.vinsoAPI.addAlertsObserver(self)
        if !currencyPairCode.isEmpty {
            handleSelectedCurrency(rawName: currencyPairCode)
        }
    }
    
    func viewWillDisappear() {
        currencyPairCode = ""
        tickerNetworkWorker.cancelRepeatLoads()
        AppDelegate.vinsoAPI.removeAlertsObserver(self)
    }
    
    func createAlert(_ alertModel: Alert) {
        print(alertModel)
        tickerNetworkWorker.cancelRepeatLoads()
        let request = AppDelegate.vinsoAPI.rx.createAlert(alert: alertModel)
        request.subscribe(onSuccess: { [weak self] success in
            guard let `self` = self else { return }
            self.output.onCreateAlertSuccessful()
        }, onError: { [weak self] err in
            guard let `self` = self else { return }
            self.tickerNetworkWorker.load(timeout: FrequencyUpdateInSec.createAlert, repeat: true)
            self.output.showAlert(message: err.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    func updateAlert(_ alertModel: Alert) {
        let request = AppDelegate.vinsoAPI.rx.updateAlert(alertModel)
        request.subscribe(onSuccess: { [weak self] in
            guard let `self` = self else { return }
            self.output.updateAlertDidSuccessful()
        }, onError: { [weak self] err in
            guard let `self` = self else { return }
            self.tickerNetworkWorker.load(timeout: FrequencyUpdateInSec.createAlert, repeat: true)
            self.output.showAlert(message: err.localizedDescription)
        }).disposed(by: disposeBag)
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

extension CreateAlertInteractor: VinsoAPIConnectionDelegate {
    func onConnectionRefused(reason: String) {
        print(reason)
        output.showAlert(message: reason)
    }
}

// MARK: IOrdersNetworkWorkerDelegate
extension CreateAlertInteractor: AlertsAPIResponseDelegate {
    func onDidCreateAlertSuccessful() {
        output.onCreateAlertSuccessful()
    }

    func onDidCreateAlertError(msg: String) {
        print(msg)
        tickerNetworkWorker.load(timeout: FrequencyUpdateInSec.createAlert, repeat: true)
        output.showAlert(message: msg)
    }

    func onDidUpdateAlertSuccessful(_ alert: Alert) {
        output.updateAlertDidSuccessful()
    }

    func onDidUpdateAlertError(msg: String) {
        print(msg)
        tickerNetworkWorker.load(timeout: FrequencyUpdateInSec.createAlert, repeat: true)
        output.showAlert(message: msg)
    }
}
