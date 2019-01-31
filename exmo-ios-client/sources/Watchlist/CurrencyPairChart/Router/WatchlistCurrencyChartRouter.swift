//
//  WatchlistCurrencyChartWatchlistCurrencyChartRouter.swift
//  ExmoMobileClient
//

import UIKit

class WatchlistCurrencyChartRouter: WatchlistCurrencyChartRouterInput {
    func showViewAddAlert(_ viewController: UIViewController) {
        let moduleInit = CreateAlertModuleInitializer()
        viewController.present(UINavigationController(rootViewController: moduleInit.viewController), animated: true, completion: nil)
    }

    func showViewAddOrder(_ viewController: UIViewController) {
        let moduleInit = CreateOrderModuleInitializer()
        viewController.present(moduleInit.viewController, animated: true, completion: nil)
    }
}
