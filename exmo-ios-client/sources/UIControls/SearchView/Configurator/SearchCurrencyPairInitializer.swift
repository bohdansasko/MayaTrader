//
//  SearchModuleInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class SearchModuleInitializer {
    var viewController: SearchViewController!

    init() {
        viewController = SearchViewController()
        let configurator = SearchModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }

}
