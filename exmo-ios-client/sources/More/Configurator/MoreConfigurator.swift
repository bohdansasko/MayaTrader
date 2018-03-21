//
//  MoreMoreConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class MoreModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? MoreViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: MoreViewController) {
        let router = MoreRouter()

        let presenter = MorePresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = MoreInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        
        viewController.displayManager = MoreDataDisplayManager()
        viewController.displayManager.viewOutput = viewController.output
    }

}
