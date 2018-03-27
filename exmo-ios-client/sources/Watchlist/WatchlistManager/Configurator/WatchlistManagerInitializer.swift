//
//  WatchlistManagerWatchlistManagerInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistManagerModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var watchlistmanagerViewController: WatchlistManagerViewController!

    override func awakeFromNib() {

        let configurator = WatchlistManagerModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: watchlistmanagerViewController)
    }

}
