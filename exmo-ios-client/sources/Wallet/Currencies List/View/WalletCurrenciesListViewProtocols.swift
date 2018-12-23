//
//  WalletCurrenciesListWalletCurrenciesListViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

protocol WalletCurrenciesListViewInput: class {
    func updateWallet(_ wallet: ExmoWalletObject)
}

protocol WalletCurrenciesListViewOutput {
    func viewIsReady()
    func viewDidAppear()
    func viewWillDisappear(wallet: ExmoWalletObject)
    func handleTouchCloseVC()
}
