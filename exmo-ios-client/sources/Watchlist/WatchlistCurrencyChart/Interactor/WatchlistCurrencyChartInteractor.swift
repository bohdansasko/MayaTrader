//
//  WatchlistCurrencyChartWatchlistCurrencyChartInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class WatchlistCurrencyChartInteractor: WatchlistCurrencyChartInteractorInput {
    weak var output: WatchlistCurrencyChartInteractorOutput!
    var networkAPIHandler: BaseAPICandleChartNetworkWorker!
    var chartData: ExmoChartData? = nil
    
    func loadCurrencyPairChartHistory(currencyPair: String, period: String = "day") {
        print("start loadCurrencyPairSettings")
        networkAPIHandler.onHandleResponseSuccesfull = {
            [weak self] chartData in
            self?.chartData = chartData
            self?.output.updateChart(chartData: chartData)
        }
        networkAPIHandler.loadCurrencyPairChartHistory(currencyPair: currencyPair, period: period)
    }
}
