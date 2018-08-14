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

    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func configure(walletModel: WalletModel) {
        view.configure(walletModel: walletModel)
    }
    
    func handleCloseView() {
        interactor.saveWalletDataToCache()
        router.closeView(uiViewController: view as! UIViewController)
    }
}
