//
//  WatchlistViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol WatchlistViewInput: class {
    func presentFavouriteCurrencies(items: [WatchlistCurrency])
    func removeItem(currency: WatchlistCurrency)
    func setSubscription(_ package: ISubscriptionPackage)
    func showAlert(with bodyMsg: String)
}
