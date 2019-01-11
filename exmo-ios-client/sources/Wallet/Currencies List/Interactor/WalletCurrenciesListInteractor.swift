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

// MARK: IWalletNetworkWorkerDelegate
extension WalletCurrenciesListInteractor: WalletCurrenciesListInteractorInput {
    func viewIsReady() {
        walletNetworkWorker.delegate = self
    }
    
    func viewDidAppear() {
        walletNetworkWorker.load()
    }
    
    func saveToCache(wallet: ExmoWallet) {
        print("wallet was saved to cache")
        print(wallet.favBalances)
        dbManager.add(data: wallet.managedObject(), update: true)
    }
}

// MARK: IWalletNetworkWorkerDelegate
extension WalletCurrenciesListInteractor: IWalletNetworkWorkerDelegate {
    func onDidLoadWalletSuccessful(_ w: ExmoWallet) {
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

        var mutableWallet = w
        mutableWallet.refresh()
        output.onDidLoadWallet(mutableWallet)
    }
    
    func onDidLoadWalletFail(messageError: String?) {
        output.onDidLoadWallet(ExmoWallet(id: 0, amountBTC: 0, amountUSD: 0, balances: [], favBalances: [], dislikedBalances: []))
        print(messageError ?? "Undefined error")
    }
}
