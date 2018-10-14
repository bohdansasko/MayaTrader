//
//  WatchlistFavouriteCurrenciesPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class WatchlistFavouriteCurrenciesPresenter: WatchlistFavouriteCurrenciesModuleInput, WatchlistFavouriteCurrenciesViewOutput, WatchlistFavouriteCurrenciesInteractorOutput {

    weak var view: WatchlistFavouriteCurrenciesViewInput!
    var interactor: WatchlistFavouriteCurrenciesInteractorInput!
    var router: WatchlistFavouriteCurrenciesRouterInput!

    func viewIsReady() {

    }
}
