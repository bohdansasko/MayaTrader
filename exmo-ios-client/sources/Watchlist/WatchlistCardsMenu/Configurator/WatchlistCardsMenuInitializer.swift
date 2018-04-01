//
//  WatchlistCardsMenuWatchlistCardsMenuInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 30/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCardsMenuModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var watchlistcardsmenuViewController: WatchlistCardsMenuViewController!

    override func awakeFromNib() {

        let configurator = WatchlistCardsMenuModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: watchlistcardsmenuViewController)
    }

}
