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
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady(tableView: tableView)
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        output.handleViewWillAppear()
    }

    @IBAction func openCurrenciesManager(_ sender: Any) {
        output.openWalletSettings()
    }

    // MARK: WalletViewInput
    func setupInitialState() {
        setTouchEnabled(isTouchEnabled: false)
    }
    
    func setTouchEnabled(isTouchEnabled: Bool) {
        currencySettingsBtn.isEnabled = isTouchEnabled
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WalletSegueIdentifiers.ManageCurrencies.rawValue {
            output.sendDataToWalletSettings(segue: segue, sender: sender)
        }
    }
}
