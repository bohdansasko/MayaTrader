//
//  WalletCurrenciesListWalletCurrenciesListPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class WalletCurrenciesListPresenter: WalletCurrenciesListModuleInput, WalletCurrenciesListViewOutput, WalletCurrenciesListInteractorOutput {

    weak var view: WalletCurrenciesListViewInput!
    var interactor: WalletCurrenciesListInteractorInput!
    var router: WalletCurrenciesListRouterInput!
}

// @MARK: WalletCurrenciesListModuleInput
extension WalletCurrenciesListPresenter {
    func configure(wallet: ExmoWallet) {
        view.updateWallet(wallet)
    }
}


// @MARK: WalletCurrenciesListViewOutput
extension WalletCurrenciesListPresenter {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func viewDidAppear() {
        interactor.viewDidAppear()
    }
    
    func viewWillDisappear(wallet: ExmoWallet) {
        interactor.saveToCache(wallet: wallet)
    }
    
    func handleTouchCloseVC() {
        router.closeView(uiViewController: view as! UIViewController)
    }
}


// @MARK: WalletCurrenciesListInteractorOutput
extension WalletCurrenciesListPresenter {
    func onDidLoadWallet(_ wallet: ExmoWallet) {
        view.updateWallet(wallet)
    }
}
