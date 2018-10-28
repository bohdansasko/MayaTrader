//
//  CurrenciesGroupsConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CurrenciesGroupsModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? CurrenciesGroupsViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: CurrenciesGroupsViewController) {

        let router = CurrenciesGroupsRouter()

        let presenter = CurrenciesGroupsPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = CurrenciesGroupsInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
