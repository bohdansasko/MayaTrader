//
//  WalletSettingsWalletSettingsConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletSettingsModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WalletSettingsViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WalletSettingsViewController) {

        let router = WalletSettingsRouter()

        let presenter = WalletSettingsPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WalletSettingsInteractor()
        interactor.output = presenter
        interactor.networkWorker = ExmoWalletCurrenciesListNetworkWorker()
        
        presenter.interactor = interactor
        viewController.output = presenter
    }

}
