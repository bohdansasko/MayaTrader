//
//  WatchlistCardsMenuWatchlistCardsMenuConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 30/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCardsMenuModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WatchlistCardsMenuViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WatchlistCardsMenuViewController) {

        let router = WatchlistCardsMenuRouter()

        let presenter = WatchlistCardsMenuPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WatchlistCardsMenuInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        viewController.displayManager = WatchlistCardsDisplayManager(data: WatchlistCurrencyPairsModel())
    }

}
