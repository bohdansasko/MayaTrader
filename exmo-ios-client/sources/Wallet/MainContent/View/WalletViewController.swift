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
    var output: WalletViewOutput!
    var favCurrenciesTableView: WalletDisplayManager!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        setupInitialState()
    }

    // MARK: WalletViewInput
    func setupInitialState() {
        view.backgroundColor = .black
        currencySettingsBtn.target = self
        currencySettingsBtn.action = #selector(openCurrenciesManager(_ :))
        
        view.addSubview(glowImage)
        view.addSubview(balanceView)
        view.addSubview(favCurrenciesTableView)
        
        setupNavigationBar()
        
        glowImage.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: balanceView.bottomAnchor, right: view.rightAnchor, topConstant: -10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        balanceView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: favCurrenciesTableView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        setupCurrenciesTable()
    }
    
    func setTouchEnabled(isTouchEnabled: Bool) {
        currencySettingsBtn.isEnabled = isTouchEnabled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WalletSegueIdentifiers.ManageCurrencies.rawValue {
            output.sendDataToWalletSettings(segue: segue, sender: sender)
        }
    }
    
    func getWalletModelAsSegueBlock() -> SegueBlock? {
        return nil // favCurrenciesTableView.getWalletModelAsSegueBlock()
    }
    
    
    // MARK: IBActions
    @objc func openCurrenciesManager(_ sender: Any) {
//        output.openWalletSettings(segueBlock: favCurrenciesTableView.getWalletModelAsSegueBlock())
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
    
    private func setupCurrenciesTable() {
        favCurrenciesTableView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 128, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        favCurrenciesTableView.dataProvider = AppDelegate.session.getUser().getWalletInfo()
    }
}
