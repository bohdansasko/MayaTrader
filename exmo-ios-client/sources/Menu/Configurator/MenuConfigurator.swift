//
//  MoreMenuConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class MenuModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? TableMenuViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: TableMenuViewController) {
        let router = MenuRouter()
        
        let presenter = MenuPresenter()
        presenter.view = viewController
        presenter.router = router
        
        router.output = presenter
        
        let interactor = MenuInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
