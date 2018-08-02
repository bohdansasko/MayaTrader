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
    private weak var tableView: UITableView!
    private weak var balanceView: BalanceView!
    
    override init() {
        super.init()
        self.walletDataProvider = AppDelegate.session.getUser().getWalletInfo()
    }

    func setBalanceView(balanceView: BalanceView!) {
        self.balanceView = balanceView
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func reloadData() {
        self.walletDataProvider = AppDelegate.session.getUser().getWalletInfo()
        self.walletDataProvider.filterCurrenciesByFavourites()
        self.balanceView.btcValueLabel.text = String(walletDataProvider.getAmountMoneyInBTC())
        self.balanceView.usdValueLabel.text = String(walletDataProvider.getAmountMoneyInUSD())
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
        return self.walletDataProvider.getCountUsedCurrencies()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = self.walletDataProvider.getCurrencyByIndexPath(indexPath: indexPath, numberOfSections: 1)
        let cellId =  TableCellIdentifiers.WalletTableViewCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WalletTableViewCell
        cell.setContent(balance: currency.balance, currency: currency.currency, countInOrders: 0/*currency.countInOrders as! Int*/)
        cell.backgroundColor = (indexPath.row + 1) % 2 == 0 ? UIColor.dark : UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
