//
//  CreateOrderCreateOrderConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateOrderModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? CreateOrderViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: CreateOrderViewController) {
        let router = CreateOrderRouter()

        let presenter = CreateOrderPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = CreateOrderInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.dataDisplayManager = CreateOrderDisplayManager()
        viewController.dataDisplayManager.output = viewController.output
        viewController.pickerViewManager = DarkeningPickerViewManager(frameRect: UIScreen.main.bounds, headerString: "Order by", dataSource: ["Market", "Cryptocurrency Exchange"])
    }

}