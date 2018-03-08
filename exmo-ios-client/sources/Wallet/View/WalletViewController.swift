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
    }

    // MARK: WalletViewInput
    func setupInitialState() {
        currencySettingsBtn.isEnabled = false
    }
    
    func setTouchEnabled(isTouchEnabled: Bool) {
        currencySettingsBtn.isEnabled = isTouchEnabled
    }
}
