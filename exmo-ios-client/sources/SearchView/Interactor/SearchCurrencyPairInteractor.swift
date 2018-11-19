//
//  SearchInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Alamofire
import SwiftyJSON

class SearchInteractor {
    weak var output: SearchInteractorOutput!
    var networkWorker: ITickerNetworkWorker!
    var timerScheduler: Timer?
    
    deinit {
        print("deinit \(String(describing: self))")
    }
}

extension SearchInteractor: SearchInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
        
        scheduleUpdateCurrencies()
        loadCurrenciesPairs()
    }
    
    func viewWillDisappear() {
        print("viewWillDisappear")
        stopScheduleUpdateCurrencies()
    }
    
    func loadCurrenciesPairs() {
        networkWorker?.loadTicker()
    }
    
    private func scheduleUpdateCurrencies() {
        timerScheduler = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
            [weak self] _ in
            self?.networkWorker.loadTicker()
        }
    }
    
    private func stopScheduleUpdateCurrencies() {
        if timerScheduler != nil {
            timerScheduler?.invalidate()
            timerScheduler = nil
        }
    }
    
    func getTestData() -> [SearchCurrencyPairModel] {
        return [
            SearchCurrencyPairModel(id: 1, name: "XRP_USD", price: 0.534),
            SearchCurrencyPairModel(id: 2, name: "XRP_BTC", price: 0.00001398),
            SearchCurrencyPairModel(id: 3, name: "XRP_UAH", price: 15.78),
            
            SearchCurrencyPairModel(id: 4, name: "BTC_USD", price: 0.534),
            SearchCurrencyPairModel(id: 5, name: "ETH_BTC", price: 0.00001398),
            SearchCurrencyPairModel(id: 6, name: "RUB_UAH", price: 15.78)
        ]
    }
}

extension SearchInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        print("onDidLoadTickerSuccess")
        guard let tickerPairs = ticker?.pairs else { return }
        var searchPairs: [SearchCurrencyPairModel] = []
        
        tickerPairs.forEach({
            currencyCode, tickerCurrency in
            guard let currencyModel = tickerCurrency else { return }
            searchPairs.append(SearchCurrencyPairModel(id: 0, name: currencyCode, price: currencyModel.lastTrade))
        })
        
        output.onDidLoadCurrenciesPairs(searchPairs)
    }
    
    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("onDidLoadTickerFails")
        output.onDidLoadCurrenciesPairs([])
    }
}
