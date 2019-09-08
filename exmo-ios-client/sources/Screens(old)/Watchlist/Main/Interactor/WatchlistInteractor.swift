//
//  WatchlistInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import RealmSwift
import Alamofire
import SwiftyJSON

class WatchlistInteractor {
    weak var output: WatchlistInteractorOutput!

    var networkWorker: TickerNetworkWorker!
    var dbManager: OperationsDatabaseProtocol!
    var favPairs: [WatchlistCurrency] = []

    deinit {
        unsubscribeFromNotifications()
    }
}

// MARK: WatchlistInteractor
extension WatchlistInteractor: WatchlistInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
        subscribeOnIAPNotifications()
    }

    func viewWillAppear() {
        loadCurrenciesFromCache()
        if favPairs.count > 0 {
            networkWorker.load(timeout: FrequencyUpdateInSec.watchlist, repeat: true)
        } else {
            log.debug("Watchlist: didLoadCurrencies \(favPairs)")
            output.didLoadCurrencies(items: favPairs)
        }
    }

    func viewWillDisappear() {
        networkWorker.cancelRepeatLoads()
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

// MARK: ITickerNetworkWorkerDelegate
extension WatchlistInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        guard let tickerPairs = ticker?.pairs else { return }

        var tickerContainer: [String : WatchlistCurrency] = [:]

        for (pairCode, tickerPair) in tickerPairs {
            let isFavCurrencyPair = favPairs.contains(where: { $0.tickerPair.code == pairCode })
            if isFavCurrencyPair {
                tickerContainer[pairCode] = WatchlistCurrency(index: 0, tickerCurrencyModel: tickerPair)
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

    func onDidLoadTickerFails() {
        networkWorker.cancelRepeatLoads()
        output.onLoadTickerError(msg: "Can't retrieve data from EXMO. Please, try again later.")
    }
}

// MARK: work with database
extension WatchlistInteractor {
    func loadCurrenciesFromCache() {
        guard let object = dbManager.object(type: WatchlistObject.self, key: "") else {
            favPairs = []
            return
        }
        favPairs = convertToArray(currencies: object.pairs)
        favPairs.sort(by: { $0.index < $1.index })
        favPairs.forEach({ log.debug("code = \($0.tickerPair.code)") })
    }

    func saveFavCurrenciesToCache() {
        log.info("saveFavCurrenciesToCache")
        dbManager.add(data: convertToDBArray(currencies: favPairs), update: true)
    }
}

// MARK: helps methods
extension WatchlistInteractor {
    func parseTicker(json: JSON) {
        var tickerContainer: [String: WatchlistCurrency] = [:]

        json["data"]["ticker"].dictionaryValue.forEach({
            (pairCode, currencyDescriptionInJSON) in
            let isFavCurrencyPair = favPairs.contains(where: { $0.tickerPair.code == pairCode })
            guard let model = TickerCurrencyModel(JSONString: currencyDescriptionInJSON.description), isFavCurrencyPair == true else {
                return
            }
            tickerContainer[pairCode] = WatchlistCurrency(index: 0,  tickerCurrencyModel: model)
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
        objects.forEach({ log.debug("code = \($0.pairName), index = \($0.index)") })
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

    func deletePairsFrom(startIndex: Int) {
        var pairsForRemove = [WatchlistCurrency]()
        for idx in (startIndex..<favPairs.count) {
            pairsForRemove.append(favPairs[idx])
        }
        pairsForRemove.forEach({ removeFavCurrency($0) })
    }
}

extension WatchlistInteractor {
    func subscribeOnIAPNotifications() {
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPNotification.updateSubscription)
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onPurchaseError(_ :)),
                name: IAPNotification.purchaseError)
    }

    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WatchlistInteractor {
    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        guard let CHSubscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? CHSubscriptionPackageProtocol else {
            log.error("can't convert notification container to IAPProduct")
            let basicSubscription = CHBasicAdsSubscriptionPackage()
            if favPairs.count > basicSubscription.maxPairsInWatchlist {
                deletePairsFrom(startIndex: basicSubscription.maxPairsInWatchlist)
            }
            output.setSubscription(basicSubscription)
            return
        }

        if favPairs.count > CHSubscriptionPackage.maxPairsInWatchlist {
            deletePairsFrom(startIndex: CHSubscriptionPackage.maxPairsInWatchlist)
        }
        output.setSubscription(CHSubscriptionPackage)
    }

    @objc
    func onPurchaseError(_ notification: Notification) {
        log.debug("notification \(notification.name)")
        guard let errorMsg = notification.userInfo?[IAPService.kErrorKey] as? String else {
            log.error("can't cast error message to String")
            output.onPurchaseError(msg: "Undefined purchase error.")
            return
        }
        output.onPurchaseError(msg: errorMsg)
    }
}
