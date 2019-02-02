//
//  WatchlistCurrencyChartCurrencyChartViewOutput.swift
//  ExmoMobileClient
//

protocol CurrencyChartViewOutput {
    func viewWillAppear()

    func loadChartData(currencyPair: String, period: String)

    func onTouchAddAlert()
    func onTouchAddOrder()
}
