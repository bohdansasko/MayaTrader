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

    deinit {
        print("deinit \(String(describing: self))")
    }
}

extension SearchInteractor: SearchInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
        networkWorker.load(timeout: FrequencyUpdateInSec.searchPair, repeat: true)
    }
    
    func viewWillDisappear() {
        print("viewWillDisappear")
        networkWorker.cancelRepeatLoads()
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
            searchPairs.append(SearchCurrencyPairModel(id: 0, name: currencyCode, price: tickerCurrency.lastTrade))
        })
        
        output.onDidLoadCurrenciesPairs(searchPairs)
    }
    
    func onDidLoadTickerFails() {
        print("onDidLoadTickerFails")
        output.onDidLoadCurrenciesPairs([])
    }
}
