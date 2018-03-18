//
//  WalletSettingsWalletSettingsPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UIViewController

class WalletSettingsPresenter: WalletSettingsModuleInput, WalletSettingsViewOutput, WalletSettingsInteractorOutput {

    weak var view: WalletSettingsViewInput!
    var interactor: WalletSettingsInteractorInput!
    var router: WalletSettingsRouterInput!

    func viewIsReady(tableView: UITableView) {
        interactor.viewIsReady(tableView: tableView)
    }
    
    func configure(walletModel: WalletModel) {
        interactor.configure(walletModel: walletModel)
    }
}
