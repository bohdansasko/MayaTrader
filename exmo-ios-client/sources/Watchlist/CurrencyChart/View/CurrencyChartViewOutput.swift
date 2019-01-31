//
//  WatchlistCurrencyChartCurrencyChartViewOutput.swift
//  ExmoMobileClient
//

protocol CurrencyChartViewOutput {
    func loadChartData(currencyPair: String, period: String)

    func onTouchAddAlert()
    func onTouchAddOrder()
}
