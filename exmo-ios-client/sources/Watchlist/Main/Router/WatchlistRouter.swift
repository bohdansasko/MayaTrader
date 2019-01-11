//
//  WatchlistRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UIViewController

class WatchlistRouter: WatchlistRouterInput {

    func showCurrenciesListVC(senderVC: UIViewController) {
        let initializer = CurrenciesGroupsModuleInitializer()
        initializer.viewController = CurrenciesGroupsViewController()
        initializer.awakeFromNib()
        
        senderVC.navigationController?.pushViewController(initializer.viewController, animated: true)
    }
    
    func showChartVC(senderVC: UIViewController, currencyPairName: String) {
        let mainStoryboard = UIStoryboard(name: "Watchlist", bundle: nil)
        guard let viewController = mainStoryboard.instantiateViewController(withIdentifier: "WatchlistCurrencyChartViewController") as? WatchlistCurrencyChartViewController else { return }
        
        guard let moduleInput = viewController.output as? WatchlistCurrencyChartModuleInput else { return }
        moduleInput.setChartCurrencyPairName(currencyPairName)
        
        senderVC.navigationController?.pushViewController(viewController, animated: true)
    }
}
