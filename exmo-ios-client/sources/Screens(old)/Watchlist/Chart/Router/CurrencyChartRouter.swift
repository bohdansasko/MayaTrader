//
//  WatchlistCurrencyChartWatchlistCurrencyChartRouter.swift
//  ExmoMobileClient
//

import UIKit

final class WatchlistCurrencyChartRouter: WatchlistCurrencyChartRouterInput {
    func showViewAddAlert(_ viewController: UIViewController, pair: String) {
//        let createAlertNavController = UIStoryboard(.alerts).instantiateViewController(withIdentifier: "chCreateAlertViewController") as! UINavigationController
//        let vc = createAlertNavController.topViewController as! CHCreateAlertViewController
//        guard let mInput = vc.output as? SearchModuleOutput else { return }
//        mInput.onDidSelectCurrencyPair(rawName: pair)
//        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    func showViewAddOrder(_ viewController: UIViewController, pair: String) {
//        let moduleInit = CreateOrderModuleInitializer()
//        let moduleInput = moduleInit.viewController.output as? SearchModuleOutput
//        moduleInput?.onDidSelectCurrencyPair(rawName: pair)
//        viewController.present(moduleInit.viewController, animated: true, completion: nil)
    }
}
