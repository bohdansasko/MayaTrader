//
//  SearchCurrencyPairSearchCurrencyPairConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class SearchCurrencyPairModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? SearchCurrencyPairViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: SearchCurrencyPairViewController) {

        let router = SearchCurrencyPairRouter()

        let presenter = SearchCurrencyPairPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = SearchCurrencyPairInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
