//
//  HistoryOrdersHistoryOrdersConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class HistoryOrdersModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? HistoryOrdersViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: HistoryOrdersViewController) {

        let router = HistoryOrdersRouter()

        let presenter = HistoryOrdersPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = HistoryOrdersInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
