//
//  DealsOrdersConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class DealsOrdersModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? DealsOrdersViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: DealsOrdersViewController) {

        let router = DealsOrdersRouter()

        let presenter = DealsOrdersPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = DealsOrdersInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.displayManager = OrdersDisplayManager(data: Session.sharedInstance.getDealsOrders(), shouldUseActions: false)
    }

}
