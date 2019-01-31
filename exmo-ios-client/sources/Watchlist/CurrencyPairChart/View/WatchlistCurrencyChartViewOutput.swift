//
//  WatchlistCurrencyChartWatchlistCurrencyChartViewOutput.swift
//  ExmoMobileClient
//

protocol WatchlistCurrencyChartViewOutput {
    func loadChartData(currencyPair: String, period: String)

    func onTouchAddAlert()
    func onTouchAddOrder()
}
