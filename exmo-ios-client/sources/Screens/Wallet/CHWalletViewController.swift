//
//  CHWalletViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHWalletView
    
    fileprivate enum Segues: String {
        case manageWallet = "ManageWallet"
    }
    
    fileprivate var presenter: CHWalletCurrenciesListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchWallet()
    }
}

// MARK: - Setup

private extension CHWalletViewController {
    
    func setupUI() {
        navigationItem.title = "TAB_WALLET".localized
        setupRightBarButtonItem(image: #imageLiteral(resourcen: "icWalletOptions"), action: #selector(actManageWalletCurrencies(_:)))
        
        presenter = CHWalletCurrenciesListPresenter(tableView : contentView.currenciesTableView,
                                                    networkAPI: CHExmoAPI.shared,
                                                    database  : RealmDatabaseManager())
        presenter.delegate = self
    }
    
}

// MARK: - Actions

private extension CHWalletViewController {
    
    @objc func actManageWalletCurrencies(_ sender: Any) {
        performSegue(withIdentifier: Segues.manageWallet.rawValue)
    }
    
}

extension CHWalletViewController: CHWalletCurrenciesListPresenterDelegate {
    
    func walletCurrenciesListPresenter(_ presenter: CHWalletCurrenciesListPresenter, onWalletFetched wallet: ExmoWallet) {
        contentView.set(walletForBalanceView: wallet)
    }
    
}
