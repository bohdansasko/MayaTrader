//
//  SearchCurrencyPairSearchCurrencyPairViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol SearchCurrencyPairViewOutput {

    /**
        @author TQ0oS
        Notify presenter that view is ready
    */

    func viewIsReady()
    func handleCloseView()
    func subscribeOnSelectCurrency(callback: IntInVoidOutClosure?)
    func handleTouchOnCurrency(currencyPairId: Int)
}
