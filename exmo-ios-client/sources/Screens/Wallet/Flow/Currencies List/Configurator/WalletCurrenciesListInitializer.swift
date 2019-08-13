//
//  WalletCurrenciesListWalletCurrenciesListInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class WalletCurrenciesListModuleInitializer: NSObject {
    @IBOutlet fileprivate(set) var viewController: WalletCurrenciesListViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let configurator = WalletCurrenciesListModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)

    }

}
