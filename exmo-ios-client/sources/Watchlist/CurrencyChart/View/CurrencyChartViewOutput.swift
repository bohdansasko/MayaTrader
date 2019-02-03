//
//  WatchlistCurrencyChartCurrencyChartViewOutput.swift
//  ExmoMobileClient
//

protocol CurrencyChartViewOutput {
    func viewWillAppear()

    func loadChartData(currencyPair: String, period: String)

    func onTouchAddAlert(pair: String)
    func onTouchAddOrder(pair: String)
}
