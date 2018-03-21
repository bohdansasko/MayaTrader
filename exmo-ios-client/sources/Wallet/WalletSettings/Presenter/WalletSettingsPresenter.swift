//
//  WalletSettingsWalletSettingsPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class WalletSettingsPresenter: WalletSettingsModuleInput, WalletSettingsViewOutput, WalletSettingsInteractorOutput {

    weak var view: WalletSettingsViewInput!
    var interactor: WalletSettingsInteractorInput!
    var router: WalletSettingsRouterInput!

    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func configure(walletModel: WalletModel) {
        view.configure(walletModel: walletModel)
    }
}
