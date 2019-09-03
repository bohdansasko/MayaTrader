//
//  WatchlistCurrencyChartWatchlistCurrencyChartConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrencyChartModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? CurrencyChartViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: CurrencyChartViewController) {

        let router = WatchlistCurrencyChartRouter()

        let presenter = WatchlistCurrencyChartPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WatchlistCurrencyChartInteractor()
        interactor.networkAPIHandler = DefaultCandleChartNetworkWorker()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
