//
//  WalletSettingsDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UITableView

class WalletSettingsDisplayManager: NSObject {
    var walletDataProvider: WalletModel!
    var tableView: UITableView!
    
    init(walletDataProvider: WalletModel!) {
        super.init()
        self.walletDataProvider = walletDataProvider
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    func isDataExists() -> Bool {
        return walletDataProvider.isDataExists()
    }
}

extension WalletSettingsDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletDataProvider.getCountAllExistsCurrencies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = self.walletDataProvider.getFromGeneralContainerCurrencyByIndex(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.WalletSettingsCell.rawValue, for: indexPath) as! WalletSettingsTableViewCell
        
        cell.setContent(id: currency.id, currencyLabel: currency.currency, isFavouriteSwitcher: currency.isFavourite, onSwitchValueCallback: { [weak self] (id, isFavourite) in
            self?.walletDataProvider.setIsFavourite(id: id, isFavourite: isFavourite)
        })
        
        return cell
    }
}
