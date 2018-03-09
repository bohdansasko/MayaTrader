//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class WalletDisplayManager: NSObject {
    var walletDataProvider: WalletModel!
    var tableView: UITableView!

    override init() {
        super.init()
        self.walletDataProvider = Session.sharedInstance.user.walletInfo
    }

    func setTableView(tableView: UITableView!) {
        self.tableView = tableView

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.updateInfo()
    }

    func updateInfo() {
        self.walletDataProvider = Session.sharedInstance.user.walletInfo
        self.tableView.reloadData()
    }

    func isDataExists() -> Bool {
        return walletDataProvider.isDataExists()
    }
}

extension WalletDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletDataProvider.getCountCurrencies()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = self.walletDataProvider.getCurrencyByIndex(index: indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.WalletTableViewCell.rawValue, for: indexPath) as! WalletTableViewCell
        cell.setContent(balance: currency.balance, currency: currency.currency, countInOrders: -1/*currency.countInOrders as! Int*/)

        return cell
    }
}
