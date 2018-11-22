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
    
    func saveToCache(wallet: ExmoWallet) {
        print("wallet was saved to cache")
        dbManager.add(data: wallet, update: true)
    }
}

// @MARK: IWalletNetworkWorkerDelegate
extension WalletCurrenciesListInteractor: IWalletNetworkWorkerDelegate {
    func onDidLoadWalletSuccessful(_ w: ExmoWallet) {
        guard let cachedWallet = dbManager.object(type: ExmoUser.self, key: "")?.wallet else {
            return
        }
        cachedWallet.balances.forEach({
            currency in
            guard let iCurrency = w.balances.first(where: { $0.code == currency.code }) else { return }
            iCurrency.isFavourite = currency.isFavourite
        })
        w.refresh()
        output.onDidLoadWallet(w)
    }
    
    func onDidLoadWalletFail(messageError: String?) {
        output.onDidLoadWallet(ExmoWallet())
        print(messageError ?? "Undefined error")
    }
}
