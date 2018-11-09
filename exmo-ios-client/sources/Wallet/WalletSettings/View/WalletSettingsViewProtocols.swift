//
//  WalletSettingsWalletSettingsViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

protocol WalletSettingsViewInput: class {
    func updateWallet(_ wallet: WalletModel)
}

protocol WalletSettingsViewOutput {
    func viewIsReady()
    func viewDidAppear()
    func handleTouchCloseVC()
}
