//
//  WatchlistFavouriteCurrenciesModuleConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistFavouriteCurrenciesModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WatchlistFavouriteCurrenciesViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WatchlistFavouriteCurrenciesViewController) {

        let router = WatchlistFavouriteCurrenciesRouter()

        let presenter = WatchlistFavouriteCurrenciesPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WatchlistFavouriteCurrenciesInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
