//
//  WatchlistFavouriteCurrenciesRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UIViewController

class WatchlistFavouriteCurrenciesRouter: WatchlistFavouriteCurrenciesRouterInput {

    func showCurrenciesListVC(senderVC: UIViewController) {
        let initializer = WatchlistCurrenciesListModuleInitializer()
        initializer.watchlistcurrencieslistViewController = WatchlistCurrenciesListViewController()
        initializer.awakeFromNib()
    
        senderVC.present(initializer.watchlistcurrencieslistViewController, animated: true, completion: nil)
    }
    
    func showChartVC(senderVC: UIViewController, currencyPairName: String) {
        guard let viewController = UIStoryboard(name: "Watchlist", bundle: nil).instantiateViewController(withIdentifier: "WatchlistCurrencyChartViewController") as? WatchlistCurrencyChartViewController else { return }
        
        guard let moduleInput = viewController.output as? WatchlistCurrencyChartModuleInput else { return }
        moduleInput.setChartCurrencyPairName(currencyPairName)
        
        senderVC.navigationController?.pushViewController(viewController, animated: true)
    }
}
