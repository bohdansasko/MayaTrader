//
//  WatchlistFavouriteCurrenciesInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import RealmSwift

class WatchlistFavouriteCurrenciesInteractor: WatchlistFavouriteCurrenciesInteractorInput {
    weak var output: WatchlistFavouriteCurrenciesInteractorOutput!
    lazy var realm = try! Realm()
    
    func viewIsReady() {
        loadCurrenciesFromCache()
    }
    
    private func loadCurrenciesFromCache() {
        let objects = realm.objects(WatchlistCurrencyModel.self)
        output.didLoadCurrenciesFromCache(items: Array(objects))
    }
}
