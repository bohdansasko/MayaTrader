//
//  CreateAlertCreateAlertInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertModuleInitializer {
    var viewController: CreateAlertViewController!

    init() {
        viewController = CreateAlertViewController()
        let configurator = CreateAlertModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
