//
//  WalletSettingsWalletSettingsInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletSettingsModuleInitializer {
    var viewController: WalletSettingsViewController!

    init() {
        viewController = WalletSettingsViewController()
        let configurator = WalletSettingsModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
