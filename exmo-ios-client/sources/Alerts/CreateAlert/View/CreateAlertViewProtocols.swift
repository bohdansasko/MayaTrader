//
//  CreateAlertCreateAlertViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateAlertViewInput: class {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?)
    func setEditAlert(_ alert: Alert)
}

protocol CreateAlertViewOutput {
    func viewIsReady()
    func viewWillDisappear()
    func handleTouchOnCancelBtn()
    func handleTouchAlertBtn(alertModel: Alert, operationType: AlertOperationType)
    func showSearchViewController(searchType: SearchViewController.SearchType)
}
