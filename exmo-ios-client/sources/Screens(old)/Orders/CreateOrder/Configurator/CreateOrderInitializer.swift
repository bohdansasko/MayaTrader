//
//  CreateOrderCreateOrderInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateOrderModuleInitializer {
    var viewController: CreateOrderViewController!

    init() {
        viewController = CreateOrderViewController()
        let configurator = CreateOrderModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }

}
