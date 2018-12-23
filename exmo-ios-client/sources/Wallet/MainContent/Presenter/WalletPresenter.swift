//
//  WalletWalletPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UITableView

class WalletPresenter: WalletModuleInput {
    weak var view: WalletViewInput!
    var interactor: WalletInteractorInput!
    var router: WalletRouterInput!
}

// @MARK: WalletViewOutput
extension WalletPresenter: WalletViewOutput {
    func viewDidLoad() {
        interactor.viewDidLoad()
    }
    
    func viewDidAppear() {
        interactor.viewDidAppear()
    }
    
    func openCurrencyListVC() {
        router.openCurrencyListVC(sourceVC: view as! UIViewController)
    }
}

// @MARK: WalletViewOutput
extension WalletPresenter: WalletInteractorOutput {
    func onDidLoadWallet(_ wallet: ExmoWalletObject) {
        view.updateWallet(wallet)
    }
}
