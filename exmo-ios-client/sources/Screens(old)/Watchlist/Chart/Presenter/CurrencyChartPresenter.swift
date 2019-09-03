//
//  WatchlistCurrencyChartWatchlistCurrencyChartPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class WatchlistCurrencyChartPresenter {
    weak var view: CurrencyChartViewInput!
    var interactor: WatchlistCurrencyChartInteractorInput!
    var router: WatchlistCurrencyChartRouterInput!
}

// MARK: WatchlistCurrencyChartModuleInput
extension WatchlistCurrencyChartPresenter: WatchlistCurrencyChartModuleInput {
    func setChartCurrencyPairName(_ currencyPairName: String) {
        view.setCurrencyPair(currencyPairName)
    }
}

// MARK: CurrencyChartViewOutput
extension WatchlistCurrencyChartPresenter: CurrencyChartViewOutput {
    func viewWillAppear() {
        interactor.viewWillAppear()
    }

    func loadChartData(currencyPair: String, period: String) {
        interactor.loadCurrencyPairChartHistory(currencyPair: currencyPair, period: period)
    }

    func onTouchAddAlert(pair: String) {
        if let vc = view as? UIViewController {
            router.showViewAddAlert(vc, pair: pair)
        }
    }

    func onTouchAddOrder(pair: String) {
        if let vc = view as? UIViewController {
            router.showViewAddOrder(vc, pair: pair)
        }
    }
}

// MARK: WatchlistCurrencyChartInteractorOutput
extension WatchlistCurrencyChartPresenter: WatchlistCurrencyChartInteractorOutput {
    func updateChart(chartData: ExmoChartData?) {
        view.updateChart(chartData: chartData)
    }

    func setSubscription(_ package: CHSubscriptionPackageProtocol) {
        view.setSubscription(package)
    }
}

