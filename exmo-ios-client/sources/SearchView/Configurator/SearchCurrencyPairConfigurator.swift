//
//  SearchConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class SearchModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? SearchViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: SearchViewController) {
        let router = SearchRouter()

        let presenter = SearchPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = SearchInteractor()
        interactor.output = presenter
        interactor.networkWorker = TickerNetworkWorker()
        
        presenter.interactor = interactor
        viewController.output = presenter
        
//        viewController.displayManager = SearchDisplayManager()
//        viewController.displayManager.output = viewController.output
    }

}
