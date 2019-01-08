//
//  WatchlistPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class WatchlistPresenter: WatchlistModuleInput {
    weak var view: WatchlistViewInput!
    var interactor: WatchlistInteractorInput!
    var router: WatchlistRouterInput!
}

extension WatchlistPresenter: WatchlistViewOutput {
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

extension WatchlistPresenter: WatchlistInteractorOutput {
    func didLoadCurrencies(items: [WatchlistCurrency]) {
        view.presentFavouriteCurrencies(items: items)
    }

    func didRemoveCurrency(_ currency: WatchlistCurrency) {
        view.removeItem(currency: currency)
    }
}