//
//  WalletWalletViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, WalletViewInput {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currencySettingsBtn: UIBarButtonItem!

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
        updateNavigationBar(shouldHideNavigationBar: true)
        displayManager.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        updateNavigationBar(shouldHideNavigationBar: false)

    }

    func updateNavigationBar(shouldHideNavigationBar: Bool) {
        let dummyImage: UIImage? = shouldHideNavigationBar ? UIImage() : nil

        self.navigationController?.navigationBar.setBackgroundImage(dummyImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = dummyImage
        self.navigationController?.navigationBar.isTranslucent = shouldHideNavigationBar
    }

    // MARK: WalletViewInput
    func setupInitialState() {
        setTouchEnabled(isTouchEnabled: false)
        
        displayManager.setTableView(tableView: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLoggedIn, object: nil)
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
