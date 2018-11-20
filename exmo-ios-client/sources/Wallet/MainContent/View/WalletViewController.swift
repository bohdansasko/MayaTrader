//
//  WalletWalletViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletViewController: ExmoUIViewController, WalletViewInput {
    var currencySettingsBtn: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "icWalletOptions"), style: .done, target: nil, action: nil)
    }()
    
    var glowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icWalletGlow")
        imageView.contentMode = .center
        return imageView
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
        output.viewIsReady()
    }

    // MARK: WalletViewInput
    func setTouchEnabled(isTouchEnabled: Bool) {
        currencySettingsBtn.isEnabled = isTouchEnabled
    }
    
    @objc func openCurrenciesManager(_ sender: Any) {
        output.openCurrencyListVC()
    }
}

extension WalletViewController {
    func updateWallet(_ wallet: WalletModel) {
        balanceView.dataProvider = wallet
        tableCurrenciesView.dataProvider = wallet
    }
}

extension WalletViewController {
    func setupViews() {
        view.backgroundColor = .black
        
        currencySettingsBtn.target = self
        currencySettingsBtn.action = #selector(openCurrenciesManager(_ :))
        
        view.addSubview(glowImage)
        view.addSubview(balanceView)
        view.addSubview(tableCurrenciesView)
        
        setupNavigationBar()
        setupConstraints()
        
        //        tableCurrenciesView.dataProvider = AppDelegate.session.getUser().getWalletInfo() // TODO: check
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let titleView = UILabel()
        titleView.text = "Wallet"
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
        
        navigationItem.rightBarButtonItem = currencySettingsBtn
    }
    
    private func setupConstraints() {
        glowImage.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: balanceView.bottomAnchor, right: view.rightAnchor, topConstant: -10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        balanceView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: tableCurrenciesView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tableCurrenciesView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 128, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
