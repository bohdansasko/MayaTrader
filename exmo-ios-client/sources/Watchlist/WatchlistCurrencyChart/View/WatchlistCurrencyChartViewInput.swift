//
//  WatchlistCurrencyChartWatchlistCurrencyChartViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol WatchlistCurrencyChartViewInput: class {

    /**
        @author TQ0oS
        Setup initial state of the view
    */

    func setupInitialState()
    func updateChart(chartData: ExmoChartData?)
}
