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
    func tryCreateAlert(alertModel: Alert)
    func tryUpdateAlert(alertModel: Alert)
}

protocol CreateAlertInteractorOutput: class {
    func updateSelectedCurrency(name: String, price: Double)
    func updateSelectedSoundInUI(soundName: String)
    
    func showCurrenciesSearchView(data: [SearchCurrencyPairModel])
    func showSoundsSearchView(data: [SearchModel])
}
