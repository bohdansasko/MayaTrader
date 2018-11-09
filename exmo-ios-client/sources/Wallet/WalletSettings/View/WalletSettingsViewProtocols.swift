//
//  WalletSettingsWalletSettingsViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

protocol WalletSettingsViewInput: class {
    func configure(walletModel: WalletModel)
}

protocol WalletSettingsViewOutput {
    func viewIsReady()
    func handleCloseView()
}
