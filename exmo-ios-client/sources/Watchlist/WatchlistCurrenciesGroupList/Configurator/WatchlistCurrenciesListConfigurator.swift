//
//  WatchlistCurrenciesListWatchlistCurrenciesListConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrenciesListModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WatchlistCurrenciesListViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WatchlistCurrenciesListViewController) {

        let router = WatchlistCurrenciesListRouter()

        let presenter = WatchlistCurrenciesListPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WatchlistCurrenciesListInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
