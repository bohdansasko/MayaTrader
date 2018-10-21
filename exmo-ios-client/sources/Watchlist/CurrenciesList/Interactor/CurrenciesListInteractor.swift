//
//  CurrenciesListInteractor.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Alamofire
import SwiftyJSON

//
// MARK: ICurrenciesListNetworkWorker
//
protocol ICurrenciesListNetworkWorker: NetworkWorker {
    func loadTicker()
}

class CurrenciesListNetworkWorker: ICurrenciesListNetworkWorker {
    var onHandleResponseSuccesfull: ((Any) -> Void)?
    
    func loadTicker() {
        Alamofire.request(ExmoApiURLs.Ticker.rawValue).responseJSON {
            [weak self] response in
            self?.handleResponse(response: response)
        }
    }
}

//
// MARK: groups filter
//
protocol IFilterGroupController: class {
    func isCurrencyCodeRelativeGroup(currencyCode: String, groupName: String) -> Bool
}

class ExmoFilterGroupController: IFilterGroupController {
    func isCurrencyCodeRelativeGroup(currencyCode: String, groupName: String) -> Bool {
        let currenciesContainer = currencyCode.split(separator: "_")
        if currenciesContainer.count < 2 {
            return currencyCode.lowercased() == groupName.lowercased()
        }
        
        if let currency = currenciesContainer.first {
            return currency == groupName
        }
        
        return false
    }
}

//
// MARK: CurrenciesListInteractorInput/CurrenciesListInteractorOutput
//
protocol CurrenciesListInteractorInput: class {
    func viewIsReady()
}

protocol CurrenciesListInteractorOutput: class {
    func onDidLoadTicker(tickerData: [String : TickerCurrencyModel])
}

class CurrenciesListInteractor: CurrenciesListInteractorInput {
    weak var output: CurrenciesListInteractorOutput!
    var networkWorker: ICurrenciesListNetworkWorker!
    var filterGroupController: IFilterGroupController!
    
    private var tickerContainer: [String : TickerCurrencyModel] = [:]
    
    func viewIsReady() {
        networkWorker.onHandleResponseSuccesfull = {
            [weak self](json) in
            guard let jsonObj = json as? JSON else { return }
            self?.parseTicker(json: jsonObj)
        }
        networkWorker.loadTicker()
    }
    
    private func parseTicker(json: JSON) {
        print("loaded CurrenciesListInteractor:")
        
        json["data"]["ticker"].dictionaryValue.forEach({
            [weak self](currencyPairCode, currencyDescriptionInJSON) in
            if filterGroupController.isCurrencyCodeRelativeGroup(currencyCode: currencyPairCode, groupName: "BTC") {
                self?.tickerContainer[currencyPairCode] = TickerCurrencyModel(JSONString: currencyDescriptionInJSON.description)
            }
        })
        output.onDidLoadTicker(tickerData: tickerContainer)
    }
}
