//
//  WatchlistFavouriteCurrenciesInteractorProtocols.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol WatchlistFavouriteCurrenciesInteractorInput {
    func viewIsReady()
    func viewWillAppear()
    func viewWillDisappear()
    func updateItems(_ items: [WatchlistCurrency])
    func removeFavCurrency(_ currency: WatchlistCurrency)
}

protocol WatchlistFavouriteCurrenciesInteractorOutput: class {
    func didLoadCurrencies(items: [WatchlistCurrency])
    func didRemoveCurrency(_ currency: WatchlistCurrency)
}
