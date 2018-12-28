//
//  WatchlistFavouriteCurrenciesViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol WatchlistFavouriteCurrenciesViewOutput: class {
    func viewIsReady()
    func viewWillAppear()
    func viewWillDisappear()
    func showCurrenciesListVC()
    func handleTouchCell(watchlistCurrencyModel: WatchlistCurrency)
    func itemsOrderUpdated(_ items: [WatchlistCurrency])
}
