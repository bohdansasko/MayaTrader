//
//  WalletCurrenciesListWalletCurrenciesListInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController
import Alamofire
import SwiftyJSON

class WalletCurrenciesListInteractor {
    weak var output: WalletCurrenciesListInteractorOutput!
    var walletNetworkWorker: IWalletNetworkWorker!
    var dbManager: OperationsDatabaseProtocol!
}

// @MARK: IWalletNetworkWorkerDelegate
extension WalletCurrenciesListInteractor: WalletCurrenciesListInteractorInput {
    func viewIsReady() {
        walletNetworkWorker.delegate = self
    }
    
    func viewDidAppear() {
        walletNetworkWorker.load()
    }
    
    func saveToCache(wallet: ExmoWalletObject) {
        print("wallet was saved to cache")
        dbManager.performTransaction {
            wallet.refreshOnFavDislikeBalances()
        }
        print(wallet.favBalances)
        dbManager.add(data: wallet, update: true)
    }
}

// @MARK: IWalletNetworkWorkerDelegate
extension WalletCurrenciesListInteractor: IWalletNetworkWorkerDelegate {
    func onDidLoadWalletSuccessful(_ w: ExmoWalletObject) {
        guard let cachedWallet = dbManager.object(type: ExmoUserObject.self, key: "")?.wallet else {
            return
        }
        dbManager.performTransaction {
            cachedWallet.balances.forEach({
                cachedCurrency in
                guard let currency = w.balances.first(where: { $0.code == cachedCurrency.code }) else { return }
                currency.isFavourite = cachedCurrency.isFavourite
                currency.orderId = cachedCurrency.orderId
            })
        }
        w.refresh()
        output.onDidLoadWallet(w)
    }
    
    func onDidLoadWalletFail(messageError: String?) {
        output.onDidLoadWallet(ExmoWalletObject())
        print(messageError ?? "Undefined error")
    }
}
