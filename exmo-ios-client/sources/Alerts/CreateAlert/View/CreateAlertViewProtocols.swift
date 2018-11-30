//
//  CreateAlertCreateAlertViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateAlertViewInput: class {
    func updateSelectedCurrency(name: String, price: Double)
    func updateSelectedSoundInUI(soundName: String)
    func setAlertItem(alertItem: Alert)
}

protocol CreateAlertViewOutput {
    func viewIsReady()
    func handleTouchOnCancelBtn()
    func handleTouchAlertBtn(alertModel: Alert, operationType: AlertOperationType)
    func showSearchViewController(searchType: SearchViewController.SearchType)
    func setAlertData(alertItem: Alert)
}
