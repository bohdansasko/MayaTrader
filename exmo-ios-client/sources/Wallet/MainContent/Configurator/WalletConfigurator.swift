//
//  WalletWalletConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WalletViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WalletViewController) {

        let router = WalletRouter()

        let presenter = WalletPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WalletInteractor()
        interactor.output = presenter
        interactor.walletNetworkWorker = ExmoWalletObjectNetworkWorker()
        interactor.tickerNetworkWorker = TickerNetworkWorker()
        interactor.dbManager = RealmDatabaseManager()
        
        presenter.interactor = interactor
        viewController.output = presenter
    }

}
