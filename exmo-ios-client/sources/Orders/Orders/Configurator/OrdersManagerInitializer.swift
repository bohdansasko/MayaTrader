//
//  OrdersInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersModuleInitializer {
    var viewController: OrdersViewController!

    init() {
        viewController = OrdersViewController()
        let configurator = OrdersModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }

}
