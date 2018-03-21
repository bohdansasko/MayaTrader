//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class WalletSegueBlock: SegueBlock {
    private(set) var walletDataProvider: WalletModel!
    
    init(dataModel: WalletModel?) {
        self.walletDataProvider = dataModel
    }
}

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
        
        self.walletDataProvider = Session.sharedInstance.user.walletInfo
        
        self.reloadData()
    }

    func reloadData() {
        walletDataProvider.filterCurrenciesByFavourites()
        self.tableView.reloadData()
    }

    func isDataExists() -> Bool {
        return walletDataProvider.isDataExists()
    }
    
    func getWalletModelAsSegueBlock() -> SegueBlock? {
        return WalletSegueBlock(dataModel: walletDataProvider)
    }
}

extension WalletDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletDataProvider.getCountFavouriteCurrencies()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = self.walletDataProvider.getFromFavouriteContainerCurrencyByIndex(index: indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.WalletTableViewCell.rawValue, for: indexPath) as! WalletTableViewCell
        cell.setContent(balance: currency.balance, currency: currency.currency, countInOrders: -1/*currency.countInOrders as! Int*/)

        return cell
    }
}
