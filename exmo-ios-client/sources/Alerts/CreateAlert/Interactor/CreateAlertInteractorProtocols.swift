//
//  CreateAlertCreateAlertInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol CreateAlertInteractorInput {
    func viewIsReady()
    func viewWillDisappear()
    func createAlert(_ alertModel: Alert)
    func updateAlert(_ alertModel: Alert)
    func handleSelectedCurrency(rawName: String)
}

protocol CreateAlertInteractorOutput: class {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?)
    func onCreateAlertSuccessful()
    func showAlert(message: String)
}
