//
//  WatchlistManagerWatchlistManagerConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistManagerModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WatchlistManagerViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WatchlistManagerViewController) {

        let router = WatchlistManagerRouter()

        let presenter = WatchlistManagerPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WatchlistManagerInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
