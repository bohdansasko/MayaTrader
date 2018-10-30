//
//  WatchlistFavouriteCurrenciesInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol WatchlistFavouriteCurrenciesInteractorOutput: class {
    func didLoadCurrenciesFromCache(items: [WatchlistCurrencyModel])
}
