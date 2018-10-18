//
//  WatchlistCurrencyChartWatchlistCurrencyChartPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class WatchlistCurrencyChartPresenter: WatchlistCurrencyChartModuleInput, WatchlistCurrencyChartViewOutput, WatchlistCurrencyChartInteractorOutput {

    weak var view: WatchlistCurrencyChartViewInput!
    var interactor: WatchlistCurrencyChartInteractorInput!
    var router: WatchlistCurrencyChartRouterInput!

    func viewIsReady() {
        // do nothing
    }
    
    func loadChartData(currencyPair: String, period: String) {
        interactor.loadCurrencyPairChartHistory(currencyPair: currencyPair, period: period)
    }
    
    func updateChart(chartData: ExmoChartData?) {
        view.updateChart(chartData: chartData)
    }
    
    func setChartCurrencyPairName(_ currencyPairName: String) {
        view.setCurrencyPair(currencyPairName)
    }
}
