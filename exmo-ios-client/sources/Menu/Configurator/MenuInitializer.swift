//
//  MoreMenuInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class MenuModuleInitializer {
    var viewController: TableMenuViewController!

    init() {
        viewController = TableMenuViewController()
        let configurator = MenuModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
