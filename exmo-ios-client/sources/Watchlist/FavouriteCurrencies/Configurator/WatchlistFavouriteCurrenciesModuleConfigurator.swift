//
//  WatchlistFavouriteCurrenciesModuleConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistFavouriteCurrenciesModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WatchlistFavouriteCurrenciesViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WatchlistFavouriteCurrenciesViewController) {

        let router = WatchlistFavouriteCurrenciesRouter()

        let presenter = WatchlistFavouriteCurrenciesPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WatchlistFavouriteCurrenciesInteractor()
        interactor.output = presenter
        interactor.networkWorker = TickerNetworkWorker()
        presenter.interactor = interactor
        viewController.output = presenter
    }

//    fileprivate func getTestData() -> [WatchlistCurrencyModel] {
//        return [
//            WatchlistCurrencyModel(index: 0, pairName: "ETH_LTC", buyPrice: 3.82002126, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 3.72920000, volume: 344.89666572, volumeCurrency: 1320.80049895),
//            WatchlistCurrencyModel(index: 1, pairName: "BTC_USD", buyPrice: 6750.00000001, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 6471.92791793, volume: 1777.63971268, volumeCurrency: 11999068.06062675),
//            WatchlistCurrencyModel(index: 2, pairName: "BTC_USD", buyPrice: 0.46100233, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 0.41792313, volume: 4068944.53664728, volumeCurrency: 1876597.22030172),
//            WatchlistCurrencyModel(index: 3, pairName: "ETH_USD", buyPrice: 215.00300001, timeUpdataInSecFrom1970: 1539544686, closeBuyPrice: 200.73272851, volume: 9640.59258642, volumeCurrency: 2072756.32795616)
//        ]
//    }
}
