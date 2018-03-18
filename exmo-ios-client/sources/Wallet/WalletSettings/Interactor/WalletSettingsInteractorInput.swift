//
//  WalletSettingsWalletSettingsInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit.UITableView

protocol WalletSettingsInteractorInput {
    func viewIsReady(tableView: UITableView)
    func configure(walletModel: WalletModel)
}
