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

    func viewIsReady(tableView: UITableView!) {
        interactor.viewIsReady(tableView: tableView)
    }

    func setTouchEnabled(isTouchEnabled: Bool) {
        view.setTouchEnabled(isTouchEnabled: isTouchEnabled)
    }
}
