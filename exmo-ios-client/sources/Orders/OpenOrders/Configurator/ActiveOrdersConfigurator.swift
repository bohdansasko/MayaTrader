//
//  OrdersOrdersConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class ActiveOrdersModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? ActiveOrdersViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: ActiveOrdersViewController) {

        let router = ActiveOrdersRouter()

        let presenter = ActiveOrdersPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = ActiveOrdersInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.displayManager = ActiveOrdersDisplayManager()
    }

}
