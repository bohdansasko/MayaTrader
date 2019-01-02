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
            print("Watchlist: didLoadCurrencies \(favPairs)")
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
        guard let index = favPairs.firstIndex(where: { $0.tickerPair.code == currency.tickerPair.code }) else {
            return
        }
        if let wobjForRemove = dbManager.object(type: WatchlistObject.self, key: "") {
            let objects: [WatchlistCurrencyObject] = wobjForRemove.pairs.filter({ $0.pairName == currency.tickerPair.code })
            if objects.count > 0 {
                favPairs.remove(at: index)
                dbManager.delete(data: objects)
            }
        }
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
        guard let object = dbManager.object(type: WatchlistObject.self, key: "") else {
            favPairs = []
            return
        }
        favPairs = convertToArray(currencies: object.pairs)
        favPairs.sort(by: { $0.index < $1.index })
        favPairs.forEach({ print("code = \($0.tickerPair.code)") })
    }

    func saveFavCurrenciesToCache() {
        print("saveFavCurrenciesToCache")
        dbManager.add(data: convertToDBArray(currencies: favPairs), update: true)
    }
}

// @MARK: work with timer
extension WatchlistFavouriteCurrenciesInteractor {
    func scheduleUpdateCurrencies() {
        print("Watchlist: scheduleUpdateCurrencies")
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
    
    func convertToArray(currencies: List<WatchlistCurrencyObject>) -> [WatchlistCurrency] {
        var objects = [WatchlistCurrency]()
        currencies.forEach({
            currency in
            objects.append(WatchlistCurrency(managedObject: currency))
        })
        return objects
    }
}


