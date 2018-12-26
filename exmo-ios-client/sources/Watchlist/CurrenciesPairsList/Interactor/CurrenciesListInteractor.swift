//
//  CurrenciesListInteractor.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

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
            if group == currenciesContainer[0] || group == currenciesContainer[1] {
                return true
            }
        }
        return false
    }
}

//
// MARK: CurrenciesListInteractorInput
//
protocol CurrenciesListInteractorInput: class {
    func viewIsReady()
    func viewWillDisappear()
    func setCurrencyGroupName(_ currencyGroupName: String)
    func cacheFavCurrencyPair(datasourceItem: Any?, isSelected: Bool)
}

//
// MARK: CurrenciesListInteractorOutput
//
protocol CurrenciesListInteractorOutput: class {
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency])
}

class CurrenciesListInteractor: CurrenciesListInteractorInput {
    weak var output: CurrenciesListInteractorOutput!
    var favouriteCurrenciesPairs: [WatchlistCurrency] = []
    var favObjectPairs: [WatchlistCurrency] = []
    var timerScheduler: Timer?
    var networkWorker: ITickerNetworkWorker!
    var filterGroupController: IFilterGroupController!
    var currencyGroupName: String = ""

    var dbManager: OperationsDatabaseProtocol!
    
    func viewIsReady() {
        networkWorker.delegate = self
        
        loadCurrenciesFromCache()
        scheduleUpdateCurrencies()
    }
    
    func viewWillDisappear() {
        saveToCache()
        stopScheduleUpdateCurrencies()
    }
    
    private func scheduleUpdateCurrencies() {
        timerScheduler = Timer.scheduledTimer(withTimeInterval: FrequencyUpdateInSec.CurrenciesList, repeats: true) {
            [weak self] _ in
            guard let self = self else { return }
            if !self.currencyGroupName.isEmpty {
                self.networkWorker.load()
            }
        }
        if !self.currencyGroupName.isEmpty {
            self.networkWorker.load()
        }
    }
    
    private func stopScheduleUpdateCurrencies() {
        if timerScheduler != nil {
            timerScheduler?.invalidate()
            timerScheduler = nil
        }
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
    
    private func loadCurrenciesFromCache() {
        guard let objects = dbManager.objects(type: WatchlistCurrencyObject.self, predicate: NSPredicate(format: "isFavourite == true", argumentArray: nil)) else {
            return
        }
        favObjectPairs = convertToArray(currencies: objects)
        favouriteCurrenciesPairs = favObjectPairs
        favouriteCurrenciesPairs = favouriteCurrenciesPairs.sorted(by: { $0.tickerPair.code < $1.tickerPair.code })
    }
    
    func saveToCache() {
        let cachedObjects = dbManager.objects(type: WatchlistCurrencyObject.self, predicate: NSPredicate(format: "isFavourite == true", argumentArray: nil))
        let cfr = favouriteCurrenciesPairs.filter{ !$0.tickerPair.isFavourite }
        let isCachedCurrenciesExists = !(cachedObjects?.isEmpty ?? true)

        if cfr.count > 0 && isCachedCurrenciesExists {
            var outdateObjects = [WatchlistCurrencyObject]()
            cachedObjects?.forEach({
                curr in
                let item = cfr.first(where: { $0.tickerPair.code == curr.pairName })
                if item != nil {
                    outdateObjects.append(curr)
                }
            })

            if outdateObjects.count > 0 {
                dbManager.delete(data: outdateObjects)
            }
        }

        let cfa = favouriteCurrenciesPairs.filter{
            fvPair in
            if !isCachedCurrenciesExists {
                return fvPair.tickerPair.isFavourite
            }
            return fvPair.tickerPair.isFavourite && cachedObjects?.firstIndex(where: { $0.pairName == fvPair.tickerPair.code }) == nil
        }

        if cfa.count > 0 {
            dbManager.add(data: convertToDBArray(currencies: cfa), update: false)
        }
    }
    
    func cacheFavCurrencyPair(datasourceItem: Any?, isSelected: Bool) {
        guard var currencyModel = datasourceItem as? WatchlistCurrency else {
            return
        }
        currencyModel.tickerPair.isFavourite = isSelected

        let itemIndex = favouriteCurrenciesPairs.firstIndex(where: { $0.tickerPair.code == currencyModel.tickerPair.code })
        if itemIndex == nil && isSelected {
            favouriteCurrenciesPairs.append(currencyModel)
        } else if let itemIdx = itemIndex {
            if let _ = favObjectPairs.firstIndex(where: { $0.tickerPair.code == currencyModel.tickerPair.code }) {
                favouriteCurrenciesPairs[itemIdx].tickerPair.isFavourite = isSelected
            } else {
                favouriteCurrenciesPairs.remove(at: itemIdx)
            }
        }
    }
}

extension CurrenciesListInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        print("onDidLoadTickerSuccess")
        guard let tickerPairs = ticker?.pairs else { return }
        
        var tickerContainer: [String : TickerCurrencyModel] = [:]
        
        tickerPairs.forEach({
            (currencyPairCode, tickerCurrencyModel) in
            if filterGroupController.isCurrencyCodeRelativeToGroup(currencyCode: currencyPairCode, currencyGroupName: currencyGroupName) {
                tickerContainer[currencyPairCode] = tickerCurrencyModel
            }
        })
        
        for index in (0..<favouriteCurrenciesPairs.count) {
            let favModel = favouriteCurrenciesPairs[index]
            if favModel.tickerPair.isFavourite && tickerContainer.contains(where: { $0.key == favModel.tickerPair.code }) {
                tickerContainer[favModel.tickerPair.code]!.isFavourite = true
            }
        }
        
        var items: [WatchlistCurrency] = tickerContainer.compactMap({(arg0) in
            let (currencyPairCode, model) = arg0
            return WatchlistCurrency(index: 1, currencyCode: currencyPairCode, tickerCurrencyModel: model)
        })
        items.sort(by: { $0.tickerPair.getChanges() > $1.tickerPair.getChanges() })
        output.onDidLoadCurrenciesPairs(items: items)
    }
    
    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("onDidLoadTickerFails")
        
    }
}

extension CurrenciesListInteractor {
    func convertToDBArray(currencies: [WatchlistCurrency]) -> [WatchlistCurrencyObject] {
        var objects = [WatchlistCurrencyObject]()
        currencies.forEach({ objects.append($0.managedObject()) })
        return objects
    }
    
    func convertToArray(currencies: Results<WatchlistCurrencyObject>) -> [WatchlistCurrency] {
        var objects = [WatchlistCurrency]()
        currencies.forEach({
            currency in
            objects.append(WatchlistCurrency(managedObject: currency))
        })
        return objects
    }
}
