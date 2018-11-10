//
//  WalletCurrenciesListWalletCurrenciesListInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol WalletCurrenciesListInteractorInput {
    func viewIsReady()
    func viewIsReadyToLoadData()
    func saveWalletDataToCache()
}

protocol WalletCurrenciesListInteractorOutput: class {
    func onDidLoadWallet(_ wallet: WalletModel)
}
