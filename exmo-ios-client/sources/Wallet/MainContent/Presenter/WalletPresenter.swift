//
//  WalletWalletPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UITableView

class WalletPresenter: WalletModuleInput, WalletViewOutput, WalletInteractorOutput {

    weak var view: WalletViewInput!
    var interactor: WalletInteractorInput!
    var router: WalletRouterInput!

    func viewDidLoad() {
        interactor.viewDidLoad()
    }
    
    func viewDidAppear() {
        interactor.viewDidAppear()
    }
    
    func openCurrencyListVC() {
        router.openCurrencyListVC(sourceVC: view as! UIViewController)
    }
    
    func onDidLoadWallet(_ wallet: ExmoWallet) {
        view.updateWallet(wallet)
    }
}
