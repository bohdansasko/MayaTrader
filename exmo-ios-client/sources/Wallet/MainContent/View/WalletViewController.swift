//
//  WalletWalletViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletViewController: ExmoUIViewController, WalletViewInput {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currencySettingsBtn: UIBarButtonItem!
    @IBOutlet weak var balanceView: BalanceView!
    
    var output: WalletViewOutput!
    var displayManager: WalletDisplayManager!

    // MARK: Life cycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayManager.reloadData()
    }

    // MARK: WalletViewInput
    func setupInitialState() {
        self.displayManager.setBalanceView(balanceView: self.balanceView)
        displayManager.setTableView(tableView: tableView)
        updateDisplayInfo();
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLogout, object: nil)
    }

    func setTouchEnabled(isTouchEnabled: Bool) {
        currencySettingsBtn.isEnabled = isTouchEnabled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WalletSegueIdentifiers.ManageCurrencies.rawValue {
            output.sendDataToWalletSettings(segue: segue, sender: sender)
        }
    }
    
    @objc func updateDisplayInfo() {
        displayManager.reloadData()
        setTouchEnabled(isTouchEnabled: displayManager.isDataExists())
    }
    
    func getWalletModelAsSegueBlock() -> SegueBlock? {
        return displayManager.getWalletModelAsSegueBlock()
    }
    
    
    // MARK: IBActions
    @IBAction func openCurrenciesManager(_ sender: Any) {
        output.openWalletSettings(segueBlock: displayManager.getWalletModelAsSegueBlock())
    }
}
