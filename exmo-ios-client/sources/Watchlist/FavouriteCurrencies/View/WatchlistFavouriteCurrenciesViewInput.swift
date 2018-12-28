//
//  WatchlistFavouriteCurrenciesViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol WatchlistFavouriteCurrenciesViewInput: class {

    /**
        @author TQ0oS
        Setup initial state of the view
    */

    func setupInitialState()
    func presentFavouriteCurrencies(items: [WatchlistCurrency])
}