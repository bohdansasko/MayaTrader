//
//  WatchlistCurrenciesListWatchlistCurrenciesListInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrenciesListModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var watchlistcurrencieslistViewController: WatchlistCurrenciesListViewController!

    override func awakeFromNib() {

        let configurator = WatchlistCurrenciesListModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: watchlistcurrencieslistViewController)
    }

}
