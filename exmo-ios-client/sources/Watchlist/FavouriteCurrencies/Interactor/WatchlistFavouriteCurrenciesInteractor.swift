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

protocol TickerNetworkWorker: NetworkWorker {
    func loadTicker()
}

class WatchlistNetworkWorker: TickerNetworkWorker {
    var onHandleResponseSuccesfull: ((Any) -> Void)?
    
    func loadTicker() {
        Alamofire.request(ExmoApiURLs.Ticker.rawValue).responseJSON{
            [weak self] response in
            self?.handleResponse(response: response)
        }
    }
}

class WatchlistFavouriteCurrenciesInteractor: WatchlistFavouriteCurrenciesInteractorInput {
    weak var output: WatchlistFavouriteCurrenciesInteractorOutput!
    var favouriteCurrenciesPairs: [WatchlistCurrencyModel] = []
    var timerScheduler: Timer?
    var networkWorker: TickerNetworkWorker!
    let config = Realm.Configuration(
        schemaVersion: 2,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
            }
    })
    lazy var realm = try! Realm()
    
    func viewIsReady() {
        Realm.Configuration.defaultConfiguration = config
//        try! realm.write {
//            realm.deleteAll()
//        }
        networkWorker.onHandleResponseSuccesfull = {
            [weak self](json) in
            guard let jsonObj = json as? JSON else { return }
            self?.parseTicker(json: jsonObj)
        }
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
