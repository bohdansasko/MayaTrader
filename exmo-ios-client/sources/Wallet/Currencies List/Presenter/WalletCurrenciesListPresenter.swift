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
    func configure(wallet: WalletModel) {
        view.updateWallet(wallet)
    }
}


// @MARK: WalletCurrenciesListViewOutput
extension WalletCurrenciesListPresenter {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func viewDidAppear() {
        interactor.viewIsReadyToLoadData()
    }
    
    func handleTouchCloseVC() {
        interactor.saveChangesToCache()
        router.closeView(uiViewController: view as! UIViewController)
    }
}


// @MARK: WalletCurrenciesListInteractorOutput
extension WalletCurrenciesListPresenter {
    func onDidLoadWallet(_ wallet: WalletModel) {
        view.updateWallet(wallet)
    }
}
