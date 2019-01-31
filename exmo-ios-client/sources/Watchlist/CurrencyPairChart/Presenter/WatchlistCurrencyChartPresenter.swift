//
//  WatchlistCurrencyChartWatchlistCurrencyChartPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrencyChartPresenter {
    weak var view: WatchlistCurrencyChartViewInput!
    var interactor: WatchlistCurrencyChartInteractorInput!
    var router: WatchlistCurrencyChartRouterInput!
}

// MARK: WatchlistCurrencyChartModuleInput
extension WatchlistCurrencyChartPresenter: WatchlistCurrencyChartModuleInput {
    func setChartCurrencyPairName(_ currencyPairName: String) {
        view.setCurrencyPair(currencyPairName)
    }
}

// MARK: WatchlistCurrencyChartViewOutput
extension WatchlistCurrencyChartPresenter: WatchlistCurrencyChartViewOutput {
    func loadChartData(currencyPair: String, period: String) {
        interactor.loadCurrencyPairChartHistory(currencyPair: currencyPair, period: period)
    }

    func onTouchAddAlert() {
        if let vc = view as? UIViewController {
            router.showViewAddAlert(vc)
        }
    }

    func onTouchAddOrder() {
        if let vc = view as? UIViewController {
            router.showViewAddOrder(vc)
        }
    }
}

// MARK: WatchlistCurrencyChartInteractorOutput
extension WatchlistCurrencyChartPresenter: WatchlistCurrencyChartInteractorOutput {
    func updateChart(chartData: ExmoChartData?) {
        view.updateChart(chartData: chartData)
    }
}

