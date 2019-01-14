//
//  MoreMenuInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class MenuModuleInitializer: ModuleInitializer {
    var viewController: UIViewController!

    init() {
        viewController = TableMenuViewController()
        let configurator = MenuModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
