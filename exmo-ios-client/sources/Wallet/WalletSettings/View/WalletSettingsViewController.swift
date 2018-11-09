//
//  WalletSettingsWalletSettingsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletSettingsViewController: UIViewController {
    var output: WalletSettingsViewOutput!

    var tabBar: CurrenciesListTabBar = {
        let tabBar = CurrenciesListTabBar()
        return tabBar
    }()
    
    var currenciesListView: WalletSettingsDisplayManager = {
        let dm = WalletSettingsDisplayManager()
        return dm
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        return aiv
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupViews()
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    @objc func closeView() {
        currenciesListView.saveChangesToSession()
        output.handleTouchCloseVC()
    }
}

// @MARK: setup views
extension WalletSettingsViewController {
    func setupViews() {
        setupNavigationBar()
        setupCurrenciesList()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
        activityIndicatorView.startAnimating()
//        if AppDelegate.isIPhone(model: .X) {
//            self.layoutConstraintHeaderHeight.constant = 95
//        }
    }
    private func setupNavigationBar() {
        view.addSubview(tabBar)
        tabBar.callbackOnTouchDoneBtn = {
            [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        tabBar.searchBar.delegate = self
        tabBar.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44)
    }
    
    private func setupCurrenciesList() {
        view.addSubview(currenciesListView)
        currenciesListView.anchor(tabBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

// @MARK: WalletSettingsViewInput
extension WalletSettingsViewController: WalletSettingsViewInput {
    func updateWallet(_ wallet: WalletModel) {
        currenciesListView.wallet = wallet
        activityIndicatorView.stopAnimating()
    }
}

// MARK: UISearchBarDelegate
extension WalletSettingsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currenciesListView.filterBy(text: searchText)
    }
}
