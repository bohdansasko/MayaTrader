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
        // do nothing
    }
    
    func showCurrenciesListVC() {
        router.showCurrenciesListVC(senderVC: view as! UIViewController)
    }
    
    func handleTouchCell(watchlistCurrencyModel: WatchlistCurrencyModel) {
        router.showChartVC(senderVC: view as! UIViewController, currencyPairName: watchlistCurrencyModel.pairName)
    }
}
