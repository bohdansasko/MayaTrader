//
//  WatchlistFlatWatchlistFlatInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistFlatModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var watchlistflatViewController: WatchlistFlatViewController!

    override func awakeFromNib() {

        let configurator = WatchlistFlatModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: watchlistflatViewController)
    }

}