//
//  WalletWalletInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletModuleInitializer {
    var viewController: WalletViewController!
    
    init() {
        viewController = WalletViewController()
        let configurator = WalletModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
