//
//  CreateAlertCreateAlertViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateAlertViewInput: class {

    /**
        @author TQ0oS
        Setup initial state of the view
    */

    func setupInitialState()
    func updateSelectedCurrency(name: String, price: Double)
    func updateSelectedSoundInUI(soundName: String)
    func setAlertItem(alertItem: AlertItem)
}
