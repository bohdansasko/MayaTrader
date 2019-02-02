//
//  WatchlistCurrencyChartCurrencyChartViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol CurrencyChartViewInput: class {
    func setupInitialState()
    func updateChart(chartData: ExmoChartData?)
    func setCurrencyPair(_ currencyPair: String)
    func setSubscription(_ package: ISubscriptionPackage)
}
