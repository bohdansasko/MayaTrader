//
//  WalletCurrenciesListWalletCurrenciesListConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletCurrenciesListModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WalletCurrenciesListViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WalletCurrenciesListViewController) {

        let router = WalletCurrenciesListRouter()

        let presenter = WalletCurrenciesListPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WalletCurrenciesListInteractor()
        interactor.output = presenter
        interactor.walletNetworkWorker = ExmoWalletObjectNetworkWorker()
        interactor.dbManager = RealmDatabaseManager()
            
        presenter.interactor = interactor
        viewController.output = presenter
    }

}
