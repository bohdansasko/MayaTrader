//
//  WatchlistCurrencySettingsWatchlistCurrencySettingsConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 29/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrencySettingsModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WatchlistCurrencySettingsViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WatchlistCurrencySettingsViewController) {

        let router = WatchlistCurrencySettingsRouter()

        let presenter = WatchlistCurrencySettingsPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WatchlistCurrencySettingsInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
