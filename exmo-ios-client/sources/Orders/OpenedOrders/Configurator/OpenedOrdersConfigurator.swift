//
//  OrdersOrdersConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OpenedOrdersModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? OpenedOrdersViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: OpenedOrdersViewController) {

        let router = OpenedOrdersRouter()

        let presenter = OpenedOrdersPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = OpenedOrdersInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.displayManager = OrdersDisplayManager(data: Session.sharedInstance.getOpenedOrders(), shouldUseActions: true)
    }

}
