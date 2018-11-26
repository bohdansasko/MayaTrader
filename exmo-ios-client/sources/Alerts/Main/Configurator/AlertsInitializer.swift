//
//  AlertsAlertsInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class AlertsModuleInitializer {
    var viewController: AlertsViewController!
    init() {
        viewController = AlertsViewController()
        let configurator = AlertsModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
