//
//  WalletWalletViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import UIKit.UITableView

protocol WalletViewInput: class {
    func setTouchEnabled(isTouchEnabled: Bool)
    func updateWallet(_ wallet: ExmoWalletObject)
}

protocol WalletViewOutput {
    func viewDidLoad()
    func viewDidAppear()
    func openCurrencyListVC()
}
