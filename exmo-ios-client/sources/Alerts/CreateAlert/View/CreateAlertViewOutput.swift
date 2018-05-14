//
//  CreateAlertCreateAlertViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CreateAlertViewOutput {

    /**
        @author TQ0oS
        Notify presenter that view is ready
    */

    func viewIsReady()
    func handleTouchOnCancelBtn()
    func handleTouchAddAlertBtn(alertModel: AlertItem)
    func handleTouchOnCurrencyPairView()
    func handleTouchOnSoundView()
}
