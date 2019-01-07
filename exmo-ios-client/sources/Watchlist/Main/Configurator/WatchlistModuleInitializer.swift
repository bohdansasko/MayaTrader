//
//  WatchlistModuleInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistModuleInitializer {
    var viewController: WatchlistViewController

    init() {
        viewController = WatchlistViewController()
        let configurator = WatchlistModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
