//
//  WalletSettingsWalletSettingsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletSettingsViewController: UIViewController, WalletSettingsViewInput {
    var output: WalletSettingsViewOutput!

    var tabBar: CurrenciesListTabBar = {
        let tabBar = CurrenciesListTabBar()
        return tabBar
    }()
    var currenciesListView: WalletSettingsDisplayManager = {
        let dm = WalletSettingsDisplayManager()
        return dm
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        view.backgroundColor = .black
        setupViews()
    }
    
    func configure(walletModel: WalletModel) {
//        currenciesListView.walletDataProvider = walletModel
    }
    
    @objc func closeView() {
        currenciesListView.saveChangesToSession()
        output.handleCloseView()
    }

}

// MARK: WalletSettingsViewInput

// @MARK:
extension WalletSettingsViewController {
    func setupViews() {
        setupNavigationBar()
        setupCurrenciesList()
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
        currenciesListView.walletDataProvider = WalletModel()
    }
}

// MARK: UISearchBarDelegate
extension WalletSettingsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard let ds = datasource as? CurrenciesListDataSource else { return }
//        ds.filterBy(text: searchText)
        currenciesListView.filterBy(text: searchText)
    }
}
