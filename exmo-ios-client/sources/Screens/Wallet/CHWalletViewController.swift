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
    
    fileprivate var presenter: CHWalletCurrenciesPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchWallet()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = Segues(rawValue: segue.identifier!)!
        switch segueId {
        case .manageWallet:
            prepareWalletManagerCurrenciesViewController(for: segue, sender: sender)
        }
    }
    
}

// MARK: - Setup

private extension CHWalletViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "TAB_WALLET".localized
        setupRightBarButtonItem(image: #imageLiteral(resourcen: "icWalletOptions"), action: #selector(actManageWalletCurrencies(_:)))
    }
    
    func setupPresenter() {
        presenter = CHWalletCurrenciesPresenter(tableView : contentView.currenciesTableView,
                                                networkAPI: CHExmoAPI.shared,
                                                database  : RealmDatabaseManager.shared)
        presenter.delegate = self
    }
    
}

// MARK: - Prepare for segue

private extension CHWalletViewController {
    
    func prepareWalletManagerCurrenciesViewController(for segue: UIStoryboardSegue, sender: Any?) {
        let vc =  segue.destination as! CHWalletCurrenciesListViewController
        vc.onClose = { [unowned self] wallet in
            if let w = wallet {
                self.presenter.saveWallet(w)
                self.presenter.wallet = w
            }
        }
    }
    
}

// MARK: - Actions

private extension CHWalletViewController {
    
    @objc func actManageWalletCurrencies(_ sender: Any) {
        performSegue(withIdentifier: Segues.manageWallet.rawValue)
    }
    
}

// MARK: - CHWalletCurrenciesPresenterDelegate

extension CHWalletViewController: CHWalletCurrenciesPresenterDelegate {
    
    func walletCurrenciesListPresenter(_ presenter: CHWalletCurrenciesPresenter, onWalletRefreshed wallet: ExmoWallet) {
        contentView.set(walletForBalanceView: wallet)
    }
    
}
