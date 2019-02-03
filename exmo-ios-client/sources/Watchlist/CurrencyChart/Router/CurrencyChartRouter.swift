//
//  WatchlistCurrencyChartWatchlistCurrencyChartRouter.swift
//  ExmoMobileClient
//

import UIKit

class WatchlistCurrencyChartRouter: WatchlistCurrencyChartRouterInput {
    func showViewAddAlert(_ viewController: UIViewController, pair: String) {
        let moduleInit = CreateAlertModuleInitializer()
        guard let mInput = moduleInit.viewController.output as? SearchModuleOutput else { return }
        mInput.onDidSelectCurrencyPair(rawName: pair)
        viewController.present(UINavigationController(rootViewController: moduleInit.viewController), animated: true, completion: nil)
    }

    func showViewAddOrder(_ viewController: UIViewController, pair: String) {
        let moduleInit = CreateOrderModuleInitializer()
        let moduleInput = moduleInit.viewController.output as? SearchModuleOutput
        moduleInput?.onDidSelectCurrencyPair(rawName: pair)
        viewController.present(moduleInit.viewController, animated: true, completion: nil)
    }
}
