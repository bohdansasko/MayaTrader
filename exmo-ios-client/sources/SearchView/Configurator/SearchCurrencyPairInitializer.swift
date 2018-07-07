//
//  SearchModuleInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class SearchModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var searchCurrencyPairViewController: SearchViewController!

    override func awakeFromNib() {

        let configurator = SearchModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: searchCurrencyPairViewController)
    }

}
