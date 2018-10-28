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
    func isCurrencyCodeRelativeToGroup(currencyCode: String, currencyGroupName: String) -> Bool
}

class ExmoFilterGroupController: IFilterGroupController {
    func isCurrencyCodeRelativeToGroup(currencyCode: String, currencyGroupName: String) -> Bool {
        let currenciesContainer = currencyCode.split(separator: "_")
        if currenciesContainer.count < 2 {
            return currencyCode.lowercased() == currencyGroupName.lowercased()
        }
        let groups = currencyGroupName.split(separator: ",")
        for group in groups {
            if (currencyCode.contains(group)) {
                return true
            }
        }
        return false
    }
}

//
// MARK: CurrenciesListInteractorInput/CurrenciesListInteractorOutput
//
protocol CurrenciesListInteractorInput: class {
    func setCurrencyGroupName(_ currencyGroupName: String)
    func viewIsReady()
}

protocol CurrenciesListInteractorOutput: class {
    func onDidLoadTicker(tickerData: [String : TickerCurrencyModel])
}

class CurrenciesListInteractor: CurrenciesListInteractorInput {
    weak var output: CurrenciesListInteractorOutput!
    var networkWorker: ICurrenciesListNetworkWorker!
    var filterGroupController: IFilterGroupController!
    var currencyGroupName: String = ""
    
    private var tickerContainer: [String : TickerCurrencyModel] = [:]
    
    func viewIsReady() {
        networkWorker.onHandleResponseSuccesfull = {
            [weak self](json) in
            guard let jsonObj = json as? JSON else { return }
            self?.parseTicker(json: jsonObj)
        }
        loadTicker()
    }
    
    private func loadTicker() {
        if !currencyGroupName.isEmpty {
            networkWorker.loadTicker()
        }
    }
    
    private func parseTicker(json: JSON) {
        print("loaded CurrenciesListInteractor:")
        
        json["data"]["ticker"].dictionaryValue.forEach({
            [weak self](currencyPairCode, currencyDescriptionInJSON) in
            if filterGroupController.isCurrencyCodeRelativeToGroup(currencyCode: currencyPairCode, currencyGroupName: currencyGroupName) {
                self?.tickerContainer[currencyPairCode] = TickerCurrencyModel(JSONString: currencyDescriptionInJSON.description)
            }
        })
        output.onDidLoadTicker(tickerData: tickerContainer)
    }
    
    func setCurrencyGroupName(_ currencyGroupName: String) {
        if currencyGroupName == "Altcoins" {
            let allAvailableCurrencies = ["USD","EUR","RUB","PLN","TRY","UAH","BTC","LTC","DOGE","DASH","ETH","WAVES","ZEC","USDT","XMR","XRP","KICK","ETC","BCH","BTG","EOS","HBZ","BTCZ","DXT","STQ","XLM","MNX","OMG","TRX","ADA","INK","NEO","GAS","ZRX","GNT","GUSD","LSK","XEM"]
            let notAvailableGroupCurrencies = ["BTC", "ETH", "XRP", "LTC"]
            for currency in allAvailableCurrencies {
                if notAvailableGroupCurrencies.contains(where: { $0 == currency }) {
                    continue
                }
                self.currencyGroupName = self.currencyGroupName + currency + ","
            }
        } else if currencyGroupName == "Fiat" {
            self.currencyGroupName = "EUR,USD,RUB,XRP,UAH,PLN,TRY"
        } else {
            self.currencyGroupName = currencyGroupName
        }
    }
}
