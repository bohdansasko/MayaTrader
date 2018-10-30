//
//  WatchlistFavouriteCurrenciesViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol WatchlistFavouriteCurrenciesViewOutput {

    /**
        @author TQ0oS
        Notify presenter that view is ready
    */

    func viewIsReady()
    func viewWillDisappear()
    func showCurrenciesListVC()
    func handleTouchCell(watchlistCurrencyModel: WatchlistCurrencyModel)
}
