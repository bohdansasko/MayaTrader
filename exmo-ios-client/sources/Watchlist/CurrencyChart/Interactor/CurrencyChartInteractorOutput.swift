//
//  WatchlistCurrencyChartWatchlistCurrencyChartInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol WatchlistCurrencyChartInteractorOutput: class {
    func updateChart(chartData: ExmoChartData?)
    func setSubscription(_ package: ISubscriptionPackage)
}
