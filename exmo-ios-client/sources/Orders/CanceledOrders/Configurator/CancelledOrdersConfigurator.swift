//
//  CanceledOrdersCanceledOrdersConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 25/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CanceledOrdersModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? CanceledOrdersViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: CanceledOrdersViewController) {

        let router = CanceledOrdersRouter()

        let presenter = CanceledOrdersPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = CanceledOrdersInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.displayManager = OrdersDisplayManager(data: Session.sharedInstance.getCanceledOrders(), shouldUseActions: false)
    }

}
