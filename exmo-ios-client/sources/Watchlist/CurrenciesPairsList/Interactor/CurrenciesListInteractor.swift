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
import Realm

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
    func viewIsReady()
    func viewWillDisappear()
    func setCurrencyGroupName(_ currencyGroupName: String)
    func cacheFavCurrencyPair(datasourceItem: Any?)
}

protocol CurrenciesListInteractorOutput: class {
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrencyModel])
}

class CurrenciesListInteractor: CurrenciesListInteractorInput {
    weak var output: CurrenciesListInteractorOutput!
    var favouriteCurrenciesPairs: [WatchlistCurrencyModel] = []
    var timerScheduler: Timer?
    var networkWorker: ITickerNetworkWorker!
    var filterGroupController: IFilterGroupController!
    var currencyGroupName: String = ""
    let config = Realm.Configuration(
        schemaVersion: 2,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
            }
    })
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    lazy var realm = try! Realm()
    
    func viewIsReady() {
        Realm.Configuration.defaultConfiguration = config
        networkWorker.delegate = self
        
        loadCurrenciesFromCache()
        scheduleUpdateCurrencies()
    }
    
    func viewWillDisappear() {
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
        let objects = realm.objects(WatchlistCurrencyModel.self).filter({ $0.isFavourite })
        favouriteCurrenciesPairs = Array(objects)
        favouriteCurrenciesPairs = favouriteCurrenciesPairs.sorted(by: { $0.pairName < $1.pairName })
    }
    
    func cacheFavCurrencyPair(datasourceItem: Any?) {
        guard let currencyModel = datasourceItem as? WatchlistCurrencyModel else { return }
        let isInFavList = favouriteCurrenciesPairs.contains(where: { $0.pairName == currencyModel.pairName })
        if !isInFavList && currencyModel.isFavourite {
           favouriteCurrenciesPairs.append(currencyModel)
        } else {
            favouriteCurrenciesPairs.removeAll(where: { $0.pairName == currencyModel.pairName })
        }
        
        try! realm.write {
            if currencyModel.isFavourite {
                realm.add(currencyModel)
            } else {
                realm.add(currencyModel, update: true)
            }
            print("successful cached \(currencyModel)")
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
            if favModel.isFavourite && tickerContainer.contains(where: { $0.key == favModel.pairName }) {
                tickerContainer[favModel.pairName]!.isFavourite = true
            }
        }
        
        let items: [WatchlistCurrencyModel] = tickerContainer.compactMap({(arg0) in
            let (currencyPairCode, model) = arg0
            return WatchlistCurrencyModel(index: 1, currencyCode: currencyPairCode, tickerCurrencyModel: model)
        })
        
        output.onDidLoadCurrenciesPairs(items: items)
    }
    
    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("onDidLoadTickerFails")
        
    }
}
