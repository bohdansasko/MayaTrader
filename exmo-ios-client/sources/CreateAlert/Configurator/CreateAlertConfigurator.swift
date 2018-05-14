//
//  CreateAlertCreateAlertConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? CreateAlertViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: CreateAlertViewController) {

        let router = CreateAlertRouter()

        let presenter = CreateAlertPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = CreateAlertInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
