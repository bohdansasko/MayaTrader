//
//  WatchlistCurrencySettingsWatchlistCurrencySettingsInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 29/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrencySettingsModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var watchlistcurrencysettingsViewController: WatchlistCurrencySettingsViewController!

    override func awakeFromNib() {

        let configurator = WatchlistCurrencySettingsModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: watchlistcurrencysettingsViewController)
    }

}
