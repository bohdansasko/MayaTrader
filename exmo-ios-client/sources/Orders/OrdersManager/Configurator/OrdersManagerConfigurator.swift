//
//  OrdersManagerOrdersManagerConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersManagerModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? OrdersManagerViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: OrdersManagerViewController) {

        let router = OrdersManagerRouter()

        let presenter = OrdersManagerPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = OrdersManagerInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        let pickerViewManager = DeleteOrdersPickerViewManager()
        pickerViewManager.viewController = viewController
        viewController.pickerViewManager = pickerViewManager
        
        viewController.displayManager = OrdersDisplayManager()
    }

}
