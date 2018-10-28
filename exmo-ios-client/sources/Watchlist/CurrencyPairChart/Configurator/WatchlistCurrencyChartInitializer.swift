//
//  WatchlistCurrencyChartWatchlistCurrencyChartInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrencyChartModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var watchlistcurrencychartViewController: WatchlistCurrencyChartViewController!

    override func awakeFromNib() {

        let configurator = WatchlistCurrencyChartModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: watchlistcurrencychartViewController)
    }

}
