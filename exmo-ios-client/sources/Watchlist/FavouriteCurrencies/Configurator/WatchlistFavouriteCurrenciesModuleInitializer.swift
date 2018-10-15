//
//  WatchlistFavouriteCurrenciesModuleInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistFavouriteCurrenciesModuleInitializer: NSObject {

    //Connect with object on storyboard
    var watchlistmanagerViewController: WatchlistFavouriteCurrenciesViewController!

    override func awakeFromNib() {

        let configurator = WatchlistFavouriteCurrenciesModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: watchlistmanagerViewController)
    }

}
