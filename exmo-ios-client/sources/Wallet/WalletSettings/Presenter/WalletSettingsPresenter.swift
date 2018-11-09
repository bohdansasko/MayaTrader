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
}

// @MARK: WalletSettingsModuleInput
extension WalletSettingsPresenter {
    func configure(wallet: WalletModel) {
        view.updateWallet(wallet)
    }
}


// @MARK: WalletSettingsViewOutput
extension WalletSettingsPresenter {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func viewDidAppear() {
        interactor.viewIsReadyToLoadData()
    }
    
    func handleTouchCloseVC() {
        interactor.saveWalletDataToCache()
        router.closeView(uiViewController: view as! UIViewController)
    }
}


// @MARK: WalletSettingsInteractorOutput
extension WalletSettingsPresenter {
    func onDidLoadWallet(_ wallet: WalletModel) {
        view.updateWallet(wallet)
    }
}
