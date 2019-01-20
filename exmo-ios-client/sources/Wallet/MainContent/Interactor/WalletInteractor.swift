//
//  WalletWalletInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class WalletInteractor: WalletInteractorInput {
    weak var output: WalletInteractorOutput!
    
    var walletNetworkWorker: IWalletNetworkWorker!
    var tickerNetworkWorker: ITickerNetworkWorker!
    var dbManager: OperationsDatabaseProtocol!
    
    var walletModel: ExmoWallet?
    var ticker: Ticker? {
        didSet {
            tryUpdateWallet()
        }
    }
    
    func viewDidLoad() {
        walletNetworkWorker.delegate = self
        tickerNetworkWorker.delegate = self
    }
    
    func viewDidAppear() {
        if Defaults.isUserLoggedIn() {
            loadWallet()
        } else {
            output.onDidLoadWallet(ExmoWallet(id: 0, amountBTC: 0, amountUSD: 0, balances: [], favBalances: [], dislikedBalances: []))
        }
    }
    
    deinit {
        print("[wallet]: deinit \(String(describing: self))")
    }
}

extension WalletInteractor {
    // TODO: this should use with timer
    func loadWallet() {
        walletModel = nil
        ticker = nil
        
        tickerNetworkWorker.load()
        walletNetworkWorker.load()
    }
    
    func tryUpdateWallet() {
        if dbManager.isInWriteTransaction() {
            return
        }
        calculateBalance()
        guard var wm = walletModel, let _ = ticker else {
            return
        }
        wm.refresh()
        output.onDidLoadWallet(wm)
    }
}

// MARK: IWalletNetworkWorkerDelegate
extension WalletInteractor: IWalletNetworkWorkerDelegate {
    func onDidLoadWalletSuccessful(_ w: ExmoWallet) {
        guard let cachedWallet = dbManager.object(type: ExmoWalletObject.self, key: "") else {
            print("can't read object ExmoWalletObject from db")
            return
        }
        cachedWallet.balances.forEach({
            cachedCurrency in
            guard let iCurrency = w.balances.first(where: { $0.code == cachedCurrency.code }) else { return }
            dbManager.performTransaction {
                cachedCurrency.balance = iCurrency.balance
                cachedCurrency.countInOrders = iCurrency.countInOrders
            }
        })
        self.walletModel = ExmoWallet(managedObject: cachedWallet)
        tryUpdateWallet()
    }
    
    func onDidLoadWalletFail(messageError: String?) {
        print(messageError ?? "Error")
    }
}

extension WalletInteractor: ITickerNetworkWorkerDelegate {
    func onDidLoadTickerSuccess(_ ticker: Ticker?) {
        self.ticker = ticker
    }
    
    func onDidLoadTickerFails() {
        print("[Wallet]: faid to load ticker")
    }
}

extension WalletInteractor {
    func calculateBalance() {
        guard let wm = walletModel,
              let tickerPairs = ticker?.pairs
        else {
            return
        }
        
        var amountBTC: Double = 0
        var amountUSD: Double = 0
        
        for currency in wm.balances {
            if currency.balance > 0 {
                print(currency.code)
                if let btcTicker = tickerPairs[currency.code + "_BTC"] {
                    amountBTC += (currency.balance * btcTicker.buyPrice)
                }
                if let usdTicker = tickerPairs[currency.code + "_USD"] {
                    amountUSD += (currency.balance * usdTicker.buyPrice)
                }
            }
        }

        walletModel?.amountBTC = amountBTC
        walletModel?.amountUSD = amountUSD
    }
}
