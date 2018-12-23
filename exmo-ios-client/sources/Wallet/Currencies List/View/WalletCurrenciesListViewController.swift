//
//  WalletCurrenciesListViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletCurrenciesListViewController: ExmoUIViewController {
    var output: WalletCurrenciesListViewOutput!

    var tabBar: CurrenciesListTabBar = {
        let tabBar = CurrenciesListTabBar()
        return tabBar
    }()
    
    var currenciesListView: WalletCurrenciesListView = {
        let dm = WalletCurrenciesListView()
        return dm
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let w = currenciesListView.wallet else { return }
        output.viewWillDisappear(wallet: w)
    }
    
    @objc func closeView() {
        output.handleTouchCloseVC()
    }
}

// @MARK: setup views
extension WalletCurrenciesListViewController {
    func setupViews() {
        setupNavigationBar()
        setupCurrenciesList()
        showLoader()
//        if AppDelegate.isIPhone(model: .X) {
//            self.layoutConstraintHeaderHeight.constant = 95
//        }
    }
    private func setupNavigationBar() {
        view.addSubview(tabBar)
        tabBar.callbackOnTouchDoneBtn = {
            [weak self] in
            self?.output.handleTouchCloseVC()
        }
        tabBar.searchBar.delegate = self
        tabBar.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44)
    }
    
    private func setupCurrenciesList() {
        view.addSubview(currenciesListView)
        currenciesListView.anchor(tabBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

// @MARK: WalletCurrenciesListViewInput
extension WalletCurrenciesListViewController: WalletCurrenciesListViewInput {
    func updateWallet(_ wallet: ExmoWalletObject) {
        currenciesListView.wallet = wallet
        hideLoader()
    }
}

// MARK: UISearchBarDelegate
extension WalletCurrenciesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currenciesListView.filterBy(text: searchText)
    }
}
