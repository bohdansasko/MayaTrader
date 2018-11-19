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
    var favouriteCurrenciesPairs: [WatchlistCurrencyModel] = []
    var timerScheduler: Timer?
    var networkWorker: TickerNetworkWorker!
    let config = Realm.Configuration(
        schemaVersion: 2,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                // do nothing
            }
    })
    lazy var realm = try! Realm()
    
    func viewIsReady() {
        Realm.Configuration.defaultConfiguration = config
//        try! realm.write {
//            realm.deleteAll()
//        }
        networkWorker.delegate = self
    }

    func viewWillAppear() {
        loadCurrenciesFromCache()
        if favouriteCurrenciesPairs.count > 0 {
            scheduleUpdateCurrencies()
        }
    }
    
    func viewWillDisappear() {
        stopScheduleUpdateCurrencies()
        saveFavCurrenciesToCache()
    }
    
    private func scheduleUpdateCurrencies() {
        timerScheduler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] _ in
            self?.networkWorker.loadTicker()
        }
    }
    
    private func loadCurrenciesFromCache() {
        let objects = realm.objects(WatchlistCurrencyModel.self).filter({ $0.isFavourite })
        favouriteCurrenciesPairs = Array(objects)
        favouriteCurrenciesPairs = favouriteCurrenciesPairs.sorted(by: { $0.pairName < $1.pairName })
        output.didLoadCurrencies(items: favouriteCurrenciesPairs)
    }
    
    private func parseTicker(json: JSON) {
        print("Loaded ticker for Watchlist")
        
        var tickerContainer: [String : WatchlistCurrencyModel] = [:]
        var currencyIndex = 0
        
        json["data"]["ticker"].dictionaryValue.forEach({
            (currencyPairCode, currencyDescriptionInJSON) in
            let isFavCurrencyPair = favouriteCurrenciesPairs.contains(where: { $0.pairName == currencyPairCode })
            guard let model = TickerCurrencyModel(JSONString: currencyDescriptionInJSON.description), isFavCurrencyPair == true else { return }
            tickerContainer[currencyPairCode] = WatchlistCurrencyModel(index: currencyIndex, currencyCode: currencyPairCode, tickerCurrencyModel: model)
            currencyIndex = currencyIndex + 1
        })
        
        for favCurrencyIndex in (0..<favouriteCurrenciesPairs.count) {
            let model = favouriteCurrenciesPairs[favCurrencyIndex]
            favouriteCurrenciesPairs[favCurrencyIndex] = tickerContainer[model.pairName]!
            favouriteCurrenciesPairs[favCurrencyIndex].isFavourite = model.isFavourite
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
        try! realm.write {
            realm.add(favouriteCurrenciesPairs, update: true)
        }
    }
}

extension WatchlistFavouriteCurrenciesInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        print("onDidLoadTickerSuccess")
        guard let tickerPairs = ticker?.pairs else { return }
        
        var tickerContainer: [String : WatchlistCurrencyModel] = [:]
        var currencyIndex = 0
        
        tickerPairs.forEach({
            (currencyPairCode, currencyModel) in
            let isFavCurrencyPair = favouriteCurrenciesPairs.contains(where: { $0.pairName == currencyPairCode })
            if currencyModel != nil && isFavCurrencyPair == true {
                tickerContainer[currencyPairCode] = WatchlistCurrencyModel(index: currencyIndex, currencyCode: currencyPairCode, tickerCurrencyModel: currencyModel!)
                currencyIndex = currencyIndex + 1
            }
        })
        
        for favCurrencyIndex in (0..<favouriteCurrenciesPairs.count) {
            let model = favouriteCurrenciesPairs[favCurrencyIndex]
            favouriteCurrenciesPairs[favCurrencyIndex] = tickerContainer[model.pairName]!
            favouriteCurrenciesPairs[favCurrencyIndex].isFavourite = model.isFavourite
        }
        
        output.didLoadCurrencies(items: favouriteCurrenciesPairs)
        
    }
    
    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("onDidLoadTickerFails")
        
    }
}

