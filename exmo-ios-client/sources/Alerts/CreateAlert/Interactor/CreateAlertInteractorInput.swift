//
//  CreateAlertCreateAlertInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol CreateAlertInteractorInput {
    func handleSelectedCurrency(currencyId: Int)
    func handleSelectedSound(soundId: Int)
    func showCurrenciesSearchView()
    func showSoundsSearchView()
    func tryCreateAlert(alertModel: AlertItem)
    func tryUpdateAlert(alertModel: AlertItem)
}
