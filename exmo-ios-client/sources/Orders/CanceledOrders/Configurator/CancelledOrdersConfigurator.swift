//
//  CancelledOrdersCancelledOrdersConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 25/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CancelledOrdersModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? CancelledOrdersViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: CancelledOrdersViewController) {

        let router = CancelledOrdersRouter()

        let presenter = CancelledOrdersPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = CancelledOrdersInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.displayManager = OrdersDisplayManager(data: Session.sharedInstance.getCancelledOrders(), shouldUseActions: false)
    }

}
