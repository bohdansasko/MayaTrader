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
        setupNotificationsSubscription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchWallet()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    }
    
    func setupPresenter() {
        presenter = CHWalletCurrenciesPresenter(tableView: contentView.currenciesTableView,
                                                exmoAPI  : exmoAPI,
                                                vinsoAPI : vinsoAPI,
                                                database : RealmDatabaseManager.shared)
        presenter.delegate = self
    }
    
    func setupNotificationsSubscription() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotificationUserAuthorization(_:)),
                                               name: AuthorizationNotification.userFailSignIn)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotificationUserAuthorization(_:)),
                                               name: AuthorizationNotification.userSignIn)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotificationUserAuthorization(_:)),
                                               name: AuthorizationNotification.userSignOut)
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

// MARK: - Notifications

private extension CHWalletViewController {
    
    @objc func handleNotificationUserAuthorization(_ notification: Notification) {
        presenter.fetchWallet()
    }
    
}

// MARK: - CHWalletCurrenciesPresenterDelegate

extension CHWalletViewController: CHWalletCurrenciesPresenterDelegate {
    
    func walletCurrenciesListPresenter(_ presenter: CHWalletCurrenciesPresenter, onWalletRefreshed wallet: ExmoWallet?, balance walletBalance: CHWalletBalance?) {
        let isWalletExist = wallet != nil
        
        contentView.isWalletVisible = isWalletExist
        contentView.setTutorialVisible(isUserAuthorizedToExmo: exmoAPI.isAuthorized, hasContent: isWalletExist)
        
        if isWalletExist {
            contentView.set(balance: walletBalance!)
            if navigationItem.rightBarButtonItem == nil {
                setupRightBarButtonItem(image: #imageLiteral(resourceName: "icWalletOptions"), action: #selector(actManageWalletCurrencies(_:)))
            }
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
}
