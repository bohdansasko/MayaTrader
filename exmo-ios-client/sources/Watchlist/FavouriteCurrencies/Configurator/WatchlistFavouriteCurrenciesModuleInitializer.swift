//
//  WatchlistFavouriteCurrenciesModuleInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistFavouriteCurrenciesModuleInitializer {
    var viewController: WatchlistFavouriteCurrenciesViewController

    init() {
        viewController = WatchlistFavouriteCurrenciesViewController()
        let configurator = WatchlistFavouriteCurrenciesModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
