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

protocol IWalletHelpsMethods {
    func parseTicker(json: JSON) -> [String : WatchlistCurrencyModel]
    func calculateBalance( _ wm: inout WalletModel, _ tickerContainer: [String : WatchlistCurrencyModel])
}

class WalletInteractor: WalletInteractorInput {
    weak var output: WalletInteractorOutput!
    var networkWorker: IWalletNetworkWorker!
    var walletModel: WalletModel? {
        didSet {
            tryUpdateWallet()
        }
    }
    
    var tickerContainer: [String : WatchlistCurrencyModel]? {
        didSet {
            tryUpdateWallet()
        }
    }
    
    func viewDidLoad() {
        subscribeOnEvents()
    }
    
    func viewIsReady() {
        if AppDelegate.session.isExmoAccountExists() {
            loadWallet()
        }
    }
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
        AppDelegate.notificationController
    }
}

extension WalletInteractor {
    func loadWallet() {
        walletModel = nil
        tickerContainer = nil
        
        networkWorker.loadWalletInfo()
        networkWorker.loadTicker()
    }
    
    func tryUpdateWallet() {
        guard var wm = walletModel, let tc = tickerContainer else { return }
        calculateBalance(&wm, tc)
        output.onDidLoadWallet(wm)
    }
    
    func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserSignIn), name: .UserSignIn)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserSignOut), name: .UserSignOut)
    }
    
    @objc func onUserSignIn() {
        loadWallet()
    }
    
    @objc func onUserSignOut() {
        self.output.onDidLoadWallet(WalletModel())
    }
}

// @MARK: IWalletNetworkWorkerDelegate
extension WalletInteractor: IWalletNetworkWorkerDelegate {
    func onDidLoadWalletInfo(response: DataResponse<Any>) {
        switch response.result {
        case .success(_):
            do {
                let json = try JSON(data: response.data!)
                guard let wallet = WalletModel(JSONString: json.description) else { return }
                walletModel = wallet
            } catch {
                print("NetworkWorker: we caught a problem in handle response")
            }
        case .failure(_):
            output.onDidLoadWallet(WalletModel())
        }
    }

    func onDidLoadTicker(response: DataResponse<Any>) {
        switch response.result {
        case .success(_):
            do {
                let json = try JSON(data: response.data!)
                tickerContainer = parseTicker(json: json)
            } catch {
                print("NetworkWorker: we caught a problem in handle response")
            }
            
        case .failure(_):
            output.onDidLoadWallet(WalletModel())
        }
    }
}

// @MARK: IWalletHelpsMethods
extension WalletInteractor: IWalletHelpsMethods {
    func parseTicker(json: JSON) -> [String : WatchlistCurrencyModel] {
        var tickerContainer: [String : WatchlistCurrencyModel] = [:]
        var currencyIndex = 0
        
        json.dictionaryValue.forEach({
            (currencyPairCode, currencyDescriptionInJSON) in
            guard let model = TickerCurrencyModel(JSONString: currencyDescriptionInJSON.description) else { return }
            tickerContainer[currencyPairCode] = WatchlistCurrencyModel(index: currencyIndex, currencyCode: currencyPairCode, tickerCurrencyModel: model)
            currencyIndex = currencyIndex + 1
        })
        
        return tickerContainer
    }
    
    func calculateBalance( _ wm: inout WalletModel, _ tickerContainer: [String : WatchlistCurrencyModel]) {
        var amountBTC: Double = 0
        var amountUSD: Double = 0
        
        for currency in wm.getAllExistsCurrencies() {
            if currency.balance > 0 {
                if let btcTicker = tickerContainer[currency.currency + "_BTC"] {
                    amountBTC = amountBTC + (currency.balance * btcTicker.buyPrice)
                }
                if let usdTicker = tickerContainer[currency.currency + "_USD"] {
                    amountUSD = amountUSD + (currency.balance * usdTicker.buyPrice)
                }
            }
        }
        
        wm.amountBTC = amountBTC
        wm.amountUSD = amountUSD
    }
}
