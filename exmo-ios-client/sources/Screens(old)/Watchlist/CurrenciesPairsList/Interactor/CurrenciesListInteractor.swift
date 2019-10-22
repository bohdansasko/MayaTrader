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

class CurrenciesListInteractor {
    weak var output: CurrenciesListInteractorOutput!
    var pairs: [WatchlistCurrency] = []
    var networkWorker: ITickerNetworkWorker!
    var filterGroupController: IFilterGroupController!
    var dbManager: OperationsDatabaseProtocol!
    var currencyGroupName: String = ""
}

extension CurrenciesListInteractor: CurrenciesListInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
        if !currencyGroupName.isEmpty {
            networkWorker.load(timeout: FrequencyUpdateInSec.currenciesList, repeat: true)
        }
        loadCurrenciesFromCache()
    }

    func viewWillDisappear() {
        networkWorker.cancelRepeatLoads()
        saveToCache()
    }

    func setCurrencyGroupName(_ currencyGroupName: String) {
        if currencyGroupName == "Altcoins" {
            let allAvailableCurrencies = ["USD","EUR","RUB","PLN","TRY","UAH","BTC","LTC",
                                          "DOGE","DASH","ETH","WAVES","ZEC","USDT","XMR","XRP","KICK","ETC","BCH","BTG",
                                          "EOS","HBZ","BTCZ","DXT","STQ","XLM","MNX","OMG","TRX","ADA","INK","NEO","GAS",
                                          "ZRX","GNT","GUSD","LSK","XEM"]
            let notAvailableGroupCurrencies = ["BTC", "ETH", "XRP", "LTC"]
            for currency in allAvailableCurrencies {
                if notAvailableGroupCurrencies.contains(where: { $0 == currency }) {
                    continue
                }
                self.currencyGroupName += currency + ","
            }
        } else if currencyGroupName == "Fiat" {
            self.currencyGroupName = "EUR,USD,RUB,UAH,PLN,TRY"
        } else {
            self.currencyGroupName = currencyGroupName
        }
    }

    func cacheFavCurrencyPair(datasourceItem: Any?, isSelected: Bool) {
        let countPairs = pairs.filter({ $0.tickerPair.isFavourite }).count + (isSelected ? 1 : -1)
        let maxPairs = IAPService.shared.subscriptionPackage.maxPairsInWatchlist

        guard countPairs <= maxPairs,
              var currencyModel = datasourceItem as? WatchlistCurrency else {
            log.error("max pairs. Can't add one more pair")
            output.onMaxAlertsSelectedError(msg: "You have already selected max quantity of pairs. For use more pairs, you need to buy one of subscriptions.")
            return
        }
        currencyModel.tickerPair.isFavourite = isSelected

        if let index = pairs.firstIndex(where: { $0.tickerPair.code == currencyModel.tickerPair.code} ) {
            pairs[index].tickerPair.isFavourite = isSelected
        } else if isSelected {
            pairs.append(currencyModel)
        }
        output.updateFavPairs(items: pairs)
    }
}

extension CurrenciesListInteractor {
    private func loadCurrenciesFromCache() {
        guard let watchlistObject = dbManager.object(type: WatchlistObject.self, key: "") else {
            return
        }
        pairs = convertToArray(currencies: watchlistObject.pairs)
    }

    func saveToCache() {
        guard let wobj = dbManager.object(type: WatchlistObject.self, key: "") else {
            let obj = WatchlistObject()
            var favPairs = pairs.filter({ $0.tickerPair.isFavourite })
            for index in (0..<favPairs.count) {
                favPairs[index].index = index
            }
            obj.pairs.append(objectsIn: convertToDBArray(currencies: &favPairs).elements)
            dbManager.add(data: obj, update: false)
            return
        }

        var wobjPairs = convertToArray(currencies: wobj.pairs)
        wobjPairs.forEach({ log.debug("wobjPairs: code = \($0.tickerPair.code), isFavourite = \($0.tickerPair.isFavourite)") })

        // remove unused pairs from db
        var removePairsIds = [String]()
        var pairsForRemove = [WatchlistCurrency]()

        let countObjPairs = wobjPairs.count
        for indexPair in (0..<countObjPairs) {
            let isCachedCurrency = wobjPairs.first(where: { $0.tickerPair.code == pairs[indexPair].tickerPair.code }) != nil
            if !pairs[indexPair].tickerPair.isFavourite && isCachedCurrency {
                log.debug("remove \(pairs[indexPair].tickerPair.code)")
                removePairsIds.append(pairs[indexPair].tickerPair.code)
                pairsForRemove.append(pairs[indexPair])
            }
        }

        wobjPairs.removeAll(where: {
            objCurrency in
            return pairsForRemove.contains(where: { $0.tickerPair.code == objCurrency.tickerPair.code })
        })

        if !removePairsIds.isEmpty {
            if let wobjForRemove = dbManager.object(type: WatchlistObject.self, key: "") {
                let objects: [WatchlistCurrencyObject] = wobjForRemove.pairs.filter({ removePairsIds.contains($0.pairName) })
                if objects.count > 0 {
                    dbManager.delete(data: objects)
                }
            }
        }
        log.info("==========")

        // add new selected currencies to db
        var newPairs = self.pairs.filter({
            cachedCurr in
            cachedCurr.tickerPair.isFavourite
         && wobjPairs.first(where: { $0.tickerPair.code == cachedCurr.tickerPair.code }) == nil
        })

        if newPairs.count > 0 {
            newPairs.forEach({ log.debug("append \($0.tickerPair.code)") })

            dbManager.performTransaction {
                for index in (0..<wobj.pairs.count) {
                    wobj.pairs[index].index = index
                }
            }

            for index in (0..<newPairs.count) {
                newPairs[index].index = index + wobj.pairs.count
            }

            let rlmNewPairs = self.convertToDBArray(currencies: &newPairs)
            dbManager.performTransaction {
                wobj.pairs.append(objectsIn: rlmNewPairs)
            }
        }
    }
}

extension CurrenciesListInteractor {
    func convertToDBArray(currencies: inout [WatchlistCurrency]) -> List<WatchlistCurrencyObject> {
        let objects = List<WatchlistCurrencyObject>()
        for pairIndex in (0..<currencies.count) {
            objects.append(currencies[pairIndex].managedObject())
        }
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

extension CurrenciesListInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        guard let tickerPairs = ticker?.pairs else { return }
        
        var tickerContainer: [String : TickerCurrencyModel] = [:]
        
        tickerPairs.forEach({
            (currencyPairCode, tickerCurrencyModel) in
            if filterGroupController.isCurrencyCodeRelativeToGroup(currencyCode: currencyPairCode, currencyGroupName: currencyGroupName) {
                tickerContainer[currencyPairCode] = tickerCurrencyModel
            }
        })
        
        for index in (0..<pairs.count) {
            let favModel = pairs[index]
            if favModel.tickerPair.isFavourite && tickerContainer.contains(where: { $0.key == favModel.tickerPair.code }) {
                tickerContainer[favModel.tickerPair.code]!.isFavourite = true
            }
        }

        var items: [WatchlistCurrency] = tickerContainer.compactMap { arg in
            let (_, model) = arg
            return WatchlistCurrency(index: 1, tickerCurrencyModel: model)
        }
        for index in (0..<items.count) { items[index].index = index }
        items.sort(by: { $0.tickerPair.getChanges() > $1.tickerPair.getChanges() })
        output.onDidLoadCurrenciesPairs(items: items)
    }
    
    func onDidLoadTickerFails() {
        log.debug()
    }
}
