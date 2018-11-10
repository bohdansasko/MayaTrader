//
//  WalletCurrenciesListWalletCurrenciesListInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletCurrenciesListModuleInitializer {
    var viewController: WalletCurrenciesListViewController!

    init() {
        viewController = WalletCurrenciesListViewController()
        let configurator = WalletCurrenciesListModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
