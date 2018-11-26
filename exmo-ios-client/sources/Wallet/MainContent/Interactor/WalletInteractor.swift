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
            output.onDidLoadWallet(ExmoWallet())
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
        guard let wm = walletModel, let _ = ticker else {
            return
        }
        calculateBalance()
        output.onDidLoadWallet(wm)
    }
}

// @MARK: IWalletNetworkWorkerDelegate
extension WalletInteractor: IWalletNetworkWorkerDelegate {
    func onDidLoadWalletSuccessful(_ w: ExmoWallet) {
        guard let cachedWallet = dbManager.object(type: ExmoWallet.self, key: "") else {
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
        dbManager.performTransaction {
            [unowned self] in
            cachedWallet.refresh()
            self.walletModel = cachedWallet
        }
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
    
    func onDidLoadTickerFails(_ ticker: Ticker?) {
        print("[Wallet]: faid to load ticker")
    }
}

extension WalletInteractor {
    func calculateBalance() {
        guard let wm = walletModel,
              let tickerPairs = ticker?.pairs
        else { return }
        
        var amountBTC: Double = 0
        var amountUSD: Double = 0
        
        for currency in wm.balances {
            if currency.balance > 0 {
                print(currency.code)
                if let btcTicker = tickerPairs[currency.code + "_BTC"] {
                    amountBTC = amountBTC + (currency.balance * btcTicker.buyPrice)
                }
                if let usdTicker = tickerPairs[currency.code + "_USD"] {
                    amountUSD = amountUSD + (currency.balance * usdTicker.buyPrice)
                }
            }
        }
        
        wm.amountBTC = amountBTC
        wm.amountUSD = amountUSD
    }
}
