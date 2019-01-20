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
        if let viewController = view as? UIViewController {
            router.showCurrenciesListVC(senderVC: viewController)
        }
    }

    func handleTouchCell(watchlistCurrencyModel: WatchlistCurrency) {
        if let viewController = view as? UIViewController {
            router.showChartVC(senderVC: viewController, currencyPairName: watchlistCurrencyModel.tickerPair.code)
        }
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

    func setSubscription(_ package: ISubscriptionPackage) {
        view.setSubscription(package)
    }

    func onLoadTickerError(msg: String) {
        view.showAlert(with: msg)
    }

    func onPurchaseError(msg: String) {
        view.showAlert(with: msg)
    }
}
