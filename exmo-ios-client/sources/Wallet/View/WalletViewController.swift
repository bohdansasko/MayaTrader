//
//  WalletWalletViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, WalletViewInput {

    var output: WalletViewOutput!
    var walletDataProvider: WalletDataProvider!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        tableView.delegate = self
        tableView.dataSource = self
        walletDataProvider = WalletCoreDataEngine.sharedInstance.getWallet()
    }


    // MARK: WalletViewInput
    func setupInitialState() {
        // do nothing
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletDataProvider.getCurrencies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = walletDataProvider.getCurrencyByIndex(index: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as! WalletTableViewCell
        cell.setContent(balance: currency.balance, currency: currency.currency, countInOrders: currency.countInOrders)

        return cell
    }
}
