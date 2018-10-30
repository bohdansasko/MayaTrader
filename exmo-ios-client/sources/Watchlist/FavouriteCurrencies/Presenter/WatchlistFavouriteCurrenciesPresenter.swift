//
//  WatchlistFavouriteCurrenciesPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class WatchlistFavouriteCurrenciesPresenter: WatchlistFavouriteCurrenciesModuleInput, WatchlistFavouriteCurrenciesViewOutput, WatchlistFavouriteCurrenciesInteractorOutput {

    weak var view: WatchlistFavouriteCurrenciesViewInput!
    var interactor: WatchlistFavouriteCurrenciesInteractorInput!
    var router: WatchlistFavouriteCurrenciesRouterInput!

    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }
    
    func showCurrenciesListVC() {
        router.showCurrenciesListVC(senderVC: view as! UIViewController)
    }
    
    func handleTouchCell(watchlistCurrencyModel: WatchlistCurrencyModel) {
        router.showChartVC(senderVC: view as! UIViewController, currencyPairName: watchlistCurrencyModel.pairName)
    }
    
    func didLoadCurrencies(items: [WatchlistCurrencyModel]) {
        view.presentFavouriteCurrencies(items: items)
    }
}
