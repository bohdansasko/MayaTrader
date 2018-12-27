//
//  WatchlistFavouriteCurrenciesInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import RealmSwift
import Alamofire
import SwiftyJSON

class WatchlistFavouriteCurrenciesInteractor: WatchlistFavouriteCurrenciesInteractorInput {
    weak var output: WatchlistFavouriteCurrenciesInteractorOutput!
    var favouriteCurrenciesPairs: [WatchlistCurrency] = []
    var timerScheduler: Timer?
    var networkWorker: TickerNetworkWorker!
    var dbManager: OperationsDatabaseProtocol!
    
    func viewIsReady() {
        networkWorker.delegate = self
    }

    func viewWillAppear() {
        loadCurrenciesFromCache()
        if favouriteCurrenciesPairs.count > 0 {
            scheduleUpdateCurrencies()
        } else {
            output.didLoadCurrencies(items: favouriteCurrenciesPairs)
        }
    }
    
    func viewWillDisappear() {
        stopScheduleUpdateCurrencies()
        saveFavCurrenciesToCache()
    }
    
    private func scheduleUpdateCurrencies() {
        timerScheduler = Timer.scheduledTimer(withTimeInterval: FrequencyUpdateInSec.Watchlist, repeats: true) {
            [weak self] _ in
            self?.networkWorker.load()
        }
        networkWorker.load()
    }
    
    private func loadCurrenciesFromCache() {
        guard let objects = dbManager.objects(type: WatchlistCurrencyObject.self, predicate: NSPredicate(format: "isFavourite == true", argumentArray: nil)) else {
            favouriteCurrenciesPairs = []
            return
        }
        favouriteCurrenciesPairs = convertToArray(currencies: objects)
        favouriteCurrenciesPairs = favouriteCurrenciesPairs.sorted(by: { $0.index < $1.index })
    }
    
    private func parseTicker(json: JSON) {
        print("Loaded ticker for Watchlist")
        
        var tickerContainer: [String : WatchlistCurrency] = [:]
        var currencyIndex = 0
        
        json["data"]["ticker"].dictionaryValue.forEach({
            (currencyPairCode, currencyDescriptionInJSON) in
            let isFavCurrencyPair = favouriteCurrenciesPairs.contains(where: { $0.tickerPair.code == currencyPairCode })
            guard let model = TickerCurrencyModel(JSONString: currencyDescriptionInJSON.description), isFavCurrencyPair == true else { return }
            tickerContainer[currencyPairCode] = WatchlistCurrency(index: currencyIndex, currencyCode: currencyPairCode, tickerCurrencyModel: model)
            currencyIndex = currencyIndex + 1
        })
        
        for favCurrencyIndex in (0..<favouriteCurrenciesPairs.count) {
            let model = favouriteCurrenciesPairs[favCurrencyIndex]
            favouriteCurrenciesPairs[favCurrencyIndex] = tickerContainer[model.tickerPair.code]!
            favouriteCurrenciesPairs[favCurrencyIndex].tickerPair.isFavourite = model.tickerPair.isFavourite
        }
        
        output.didLoadCurrencies(items: favouriteCurrenciesPairs)
    }

    private func stopScheduleUpdateCurrencies() {
        if timerScheduler != nil {
            timerScheduler?.invalidate()
            timerScheduler = nil
        }
    }

    private func saveFavCurrenciesToCache() {
        dbManager.add(data: convertToDBArray(currencies: favouriteCurrenciesPairs), update: true)
    }
}

extension WatchlistFavouriteCurrenciesInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        print("onDidLoadTickerSuccess")
        guard let tickerPairs = ticker?.pairs else { return }
        
        var tickerContainer: [String : WatchlistCurrency] = [:]
        var currencyIndex = 0
        
        tickerPairs.forEach({
            (currencyPairCode, currencyModel) in
            let isFavCurrencyPair = favouriteCurrenciesPairs.contains(where: { $0.tickerPair.code == currencyPairCode })
            if isFavCurrencyPair == true {
                tickerContainer[currencyPairCode] = WatchlistCurrency(index: currencyIndex, currencyCode: currencyPairCode, tickerCurrencyModel: currencyModel)
                currencyIndex = currencyIndex + 1
            }
        })
        
        for favCurrencyIndex in (0..<favouriteCurrenciesPairs.count) {
            let model = favouriteCurrenciesPairs[favCurrencyIndex]
            favouriteCurrenciesPairs[favCurrencyIndex] = tickerContainer[model.tickerPair.code]!
            favouriteCurrenciesPairs[favCurrencyIndex].tickerPair.isFavourite = model.tickerPair.isFavourite
        }
        
        output.didLoadCurrencies(items: favouriteCurrenciesPairs)
        
    }
    
    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("onDidLoadTickerFails")
    }
}

extension WatchlistFavouriteCurrenciesInteractor {
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


