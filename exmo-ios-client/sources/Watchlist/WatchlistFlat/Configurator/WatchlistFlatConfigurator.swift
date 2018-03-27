//
//  WatchlistFlatWatchlistFlatConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistFlatModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WatchlistFlatViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WatchlistFlatViewController) {

        let router = WatchlistFlatRouter()

        let presenter = WatchlistFlatPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WatchlistFlatInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.displayManager = WatchlistFlatDisplayManager(data: WatchlistCurrencyPairsModel())
    }

}
