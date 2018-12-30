//
//  WatchlistFavouriteCurrenciesPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class WatchlistFavouriteCurrenciesPresenter: WatchlistFavouriteCurrenciesModuleInput {
    weak var view: WatchlistFavouriteCurrenciesViewInput!
    var interactor: WatchlistFavouriteCurrenciesInteractorInput!
    var router: WatchlistFavouriteCurrenciesRouterInput!
}

extension WatchlistFavouriteCurrenciesPresenter: WatchlistFavouriteCurrenciesViewOutput {
    func viewIsReady() {
        interactor.viewIsReady()
    }

    func viewWillAppear() {
        interactor.viewWillAppear()
    }

    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }

    func showCurrenciesListVC() {
        router.showCurrenciesListVC(senderVC: view as! UIViewController)
    }

    func handleTouchCell(watchlistCurrencyModel: WatchlistCurrency) {
        router.showChartVC(senderVC: view as! UIViewController, currencyPairName: watchlistCurrencyModel.tickerPair.code)
    }

    func itemsOrderUpdated(_ items: [WatchlistCurrency]) {
        interactor.updateItems(items)
    }

    func onTouchFavButton(currency: WatchlistCurrency) {
        interactor.removeFavCurrency(currency)
    }
}

extension WatchlistFavouriteCurrenciesPresenter: WatchlistFavouriteCurrenciesInteractorOutput {
    func didLoadCurrencies(items: [WatchlistCurrency]) {
        view.presentFavouriteCurrencies(items: items)
    }

    func didRemoveCurrency(_ currency: WatchlistCurrency) {
        view.removeItem(currency: currency)
    }
}