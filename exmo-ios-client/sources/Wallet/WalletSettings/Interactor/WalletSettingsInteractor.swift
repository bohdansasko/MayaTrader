//
//  WalletSettingsWalletSettingsInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class WalletSettingsInteractor: WalletSettingsInteractorInput {
    weak var output: WalletSettingsInteractorOutput!
    private var displayManager: WalletSettingsDisplayManager!
    
    init() {
        // do nothing
    }
    
    deinit {
        // do nothing
    }
    
    func viewIsReady(tableView: UITableView) {
        self.displayManager.setTableView(tableView: tableView)
    }

    func configure(walletModel: WalletModel) {
        self.displayManager = WalletSettingsDisplayManager(walletDataProvider: walletModel)
    }
}
