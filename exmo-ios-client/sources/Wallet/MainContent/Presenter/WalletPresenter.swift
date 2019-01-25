//
//  WalletWalletPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UITableView

class WalletPresenter {
    weak var view: WalletViewInput!
    var interactor: WalletInteractorInput!
    var router: WalletRouterInput!
}

// MARK: WalletViewOutput
extension WalletPresenter: WalletViewOutput {
    func viewDidLoad() {
        interactor.viewDidLoad()
    }
    
    func viewDidAppear() {
        interactor.viewDidAppear()
    }
    
    func openCurrencyListVC() {
        if let viewController = view as? UIViewController {
            router.openCurrencyListVC(sourceVC: viewController)
        }
    }
}

// MARK: WalletViewOutput
extension WalletPresenter: WalletInteractorOutput {
    func onDidLoadWallet(_ wallet: ExmoWallet) {
        view.updateWallet(wallet)
    }
}
