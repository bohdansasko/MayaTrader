//
//  AlertsAlertsInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class AlertsModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var alertsViewController: AlertsViewController!

    override func awakeFromNib() {

        let configurator = AlertsModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: alertsViewController)
    }

}
