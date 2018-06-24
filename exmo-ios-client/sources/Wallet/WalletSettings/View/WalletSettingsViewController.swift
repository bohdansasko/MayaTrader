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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var layoutConstraintHeaderHeight: NSLayoutConstraint!
    
    private var displayManager: WalletSettingsDisplayManager!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }
    
    // MARK: WalletSettingsViewInput
    func setupInitialState() {
        if AppDelegate.shared.isIPhone(model: .X) {
            self.layoutConstraintHeaderHeight.constant = 95
        }
        
        self.displayManager.setSearchBar(searchBar: searchBar)
        self.displayManager.setTableView(tableView: tableView)
    }
    
    func configure(walletModel: WalletModel) {
        self.displayManager = WalletSettingsDisplayManager(walletDataProvider: walletModel)
    }
    
    @IBAction func closeView() {
        output.handleCloseView()
    }

}
