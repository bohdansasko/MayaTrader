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

class WatchlistFavouriteCurrenciesInteractor {
    weak var output: WatchlistFavouriteCurrenciesInteractorOutput!
    var timerScheduler: Timer?
    var networkWorker: TickerNetworkWorker!
    var dbManager: OperationsDatabaseProtocol!
    var favPairs: [WatchlistCurrency] = []
}

// @MARK: WatchlistFavouriteCurrenciesInteractor
extension WatchlistFavouriteCurrenciesInteractor: WatchlistFavouriteCurrenciesInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
    }

    func viewWillAppear() {
        loadCurrenciesFromCache()
        if favPairs.count > 0 {
            scheduleUpdateCurrencies()
        } else {
            output.didLoadCurrencies(items: favPairs)
        }
    }

    func viewWillDisappear() {
        print("interactor: viewWillDisappear")
        stopScheduleUpdateCurrencies()
        saveFavCurrenciesToCache()
    }

    func updateItems(_ items: [WatchlistCurrency]) {
        favPairs = items
        saveFavCurrenciesToCache()
    }

    func removeFavCurrency(_ currency: WatchlistCurrency) {
        // dbManager.delete(data: currency.managedObject())
        favPairs.remove(at: currency.index)
        for index in (0..<favPairs.count) {
            favPairs[index].index = index
        }
        output.didLoadCurrencies(items: favPairs)
    }
}

// @MARK: ITickerNetworkWorkerDelegate
extension WatchlistFavouriteCurrenciesInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        print("onDidLoadTickerSuccess")
        guard let tickerPairs = ticker?.pairs else { return }

        var tickerContainer: [String : WatchlistCurrency] = [:]

        for (pairCode, tickerPair) in tickerPairs {
            let isFavCurrencyPair = favPairs.contains(where: { $0.tickerPair.code == pairCode })
            if isFavCurrencyPair {
                tickerContainer[pairCode] = WatchlistCurrency(index: 0, currencyCode: pairCode, tickerCurrencyModel: tickerPair)
            }

            if tickerContainer.count == favPairs.count {
                break
            }
        }

        for favCurrencyIndex in (0..<favPairs.count) {
            let model = favPairs[favCurrencyIndex]
            if let tickerModel = tickerContainer[model.tickerPair.code]?.tickerPair {
                favPairs[favCurrencyIndex].tickerPair = tickerModel
                favPairs[favCurrencyIndex].tickerPair.isFavourite = true
            }
        }

        output.didLoadCurrencies(items: favPairs)
    }

    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("onDidLoadTickerFails")
    }
}

// @MARK: work with database
extension WatchlistFavouriteCurrenciesInteractor {
    func loadCurrenciesFromCache() {
        guard let objects = dbManager.objects(type: WatchlistCurrencyObject.self, predicate: nil) else {
            favPairs = []
            return
        }
        favPairs = convertToArray(currencies: objects)
        favPairs.sort(by: { $0.index < $1.index })
        favPairs.forEach({ print("code = \($0.tickerPair.code), index = \($0.index)") })
    }

    func saveFavCurrenciesToCache() {
        print("saveFavCurrenciesToCache")
//        for pairIndex in (0..<favPairs.count) {
//            favPairs[pairIndex].index = pairIndex
//        }
        dbManager.add(data: convertToDBArray(currencies: favPairs), update: true)
    }
}

// @MARK: work with timer
extension WatchlistFavouriteCurrenciesInteractor {
    func scheduleUpdateCurrencies() {
        timerScheduler = Timer.scheduledTimer(withTimeInterval: FrequencyUpdateInSec.Watchlist, repeats: true) {
            [weak self] _ in
            self?.networkWorker.load()
        }
        networkWorker.load()
    }

    func stopScheduleUpdateCurrencies() {
        if timerScheduler != nil {
            timerScheduler?.invalidate()
            timerScheduler = nil
        }
    }
}

// MARK: helps methods
extension WatchlistFavouriteCurrenciesInteractor {
    func parseTicker(json: JSON) {
        print("Loaded ticker for Watchlist")

        var tickerContainer: [String: WatchlistCurrency] = [:]

        json["data"]["ticker"].dictionaryValue.forEach({
            (pairCode, currencyDescriptionInJSON) in
            let isFavCurrencyPair = favPairs.contains(where: { $0.tickerPair.code == pairCode })
            guard let model = TickerCurrencyModel(JSONString: currencyDescriptionInJSON.description), isFavCurrencyPair == true else {
                return
            }
            tickerContainer[pairCode] = WatchlistCurrency(index: 0, currencyCode: pairCode, tickerCurrencyModel: model)
        })

        for favCurrencyIndex in (0..<favPairs.count) {
            let model = favPairs[favCurrencyIndex]
            favPairs[favCurrencyIndex].tickerPair = tickerContainer[model.tickerPair.code]!.tickerPair
            favPairs[favCurrencyIndex].tickerPair.isFavourite = model.tickerPair.isFavourite
        }

        output.didLoadCurrencies(items: favPairs)
    }

    func convertToDBArray(currencies: [WatchlistCurrency]) -> [WatchlistCurrencyObject] {
        var objects = [WatchlistCurrencyObject]()
        currencies.forEach({ objects.append($0.managedObject()) })
        print("convertToDBArray")
        objects.forEach({ print("code = \($0.pairName), index = \($0.index)") })
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


