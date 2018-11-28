//
//  WalletWalletViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletViewController: ExmoUIViewController {
    var currencySettingsBtn: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "icWalletOptions"), style: .done, target: nil, action: nil)
    }()
    
    var balanceView = WalletBalanceView()
    var tableCurrenciesView = WalletTableCurrenciesView()
    
    var output: WalletViewOutput!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    @objc func openCurrenciesManager(_ sender: Any) {
        output.openCurrencyListVC()
    }
}

// MARK: WalletViewInput
extension WalletViewController: WalletViewInput {
    func setTouchEnabled(isTouchEnabled: Bool) {
        currencySettingsBtn.isEnabled = isTouchEnabled
    }
    
    func updateWallet(_ wallet: ExmoWallet) {
        balanceView.wallet = wallet
        tableCurrenciesView.wallet = wallet
    }
}

// MARK: setup initial UI state for view controller
extension WalletViewController {
    func setupViews() {
        view.backgroundColor = .black
        
        currencySettingsBtn.target = self
        currencySettingsBtn.action = #selector(openCurrenciesManager(_ :))
        
        view.addSubview(balanceView)
        view.addSubview(tableCurrenciesView)
        
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        titleNavBar = "Wallet"
        
        navigationItem.rightBarButtonItem = currencySettingsBtn
    }
    
    private func setupConstraints() {
        balanceView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: tableCurrenciesView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tableCurrenciesView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 128, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
