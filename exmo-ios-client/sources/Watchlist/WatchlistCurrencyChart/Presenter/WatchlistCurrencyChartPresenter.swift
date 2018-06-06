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

    }
}
