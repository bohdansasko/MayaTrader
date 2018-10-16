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
    private var walletDataProvider: WalletModel!
    private var filteredBalances: [WalletCurrencyModel]!
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var isSearching = false
    
    init(walletDataProvider: WalletModel!) {
        super.init()
        self.walletDataProvider = walletDataProvider
        
        self.filteredBalances = []
    }
    
    func setSearchBar(searchBar: UISearchBar!) {
        self.searchBar = searchBar
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.removeGlassIcon()
        searchBar.setInputTextFont(UIFont.getExo2Font(fontType: .Regular, fontSize: 14))
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
        self.tableView.setEditing(true, animated: true)
    }
    
    func isDataExists() -> Bool {
        return walletDataProvider.isDataExists()
    }

    func saveChangesToSession() {
        AppDelegate.session.getUser().walletInfo = walletDataProvider
    }
}

extension WalletSettingsDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundView?.backgroundColor = UIColor(red: 3.0/255.0, green: 1.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        header.textLabel?.textColor = UIColor(red: 178.0/255.0, green: 178.0/255.0, blue: 178.0/255.0, alpha: 190.0/255.0)
        header.textLabel?.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : self.walletDataProvider.getCountSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearching
            ? self.filteredBalances.isEmpty ? "NO RESULTS FOUND" : "SEARCH RESULTS"
            : self.walletDataProvider.getCountSections() == 1
                ? ""
                : section == 0 ? "SELECTED" : "UNUSED"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching
            ? self.filteredBalances.count
            : self.walletDataProvider.getCountSections() == 1
                ? self.walletDataProvider.getCountAllExistsCurrencies()
                : section == 0
                    ? self.walletDataProvider.getCountUsedCurrencies()
                    : self.walletDataProvider.getCountUnusedCurrencies()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = isSearching
            ? self.filteredBalances[indexPath.row]
            : self.walletDataProvider.getCurrencyByIndexPath(indexPath: indexPath, numberOfSections: self.walletDataProvider.getCountSections())
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.WalletSettingsCell.rawValue, for: indexPath) as! WalletSettingsTableViewCell
        cell.setContent(id: currency.orderId, currencyLabel: currency.currency, isFavourite: currency.isFavourite, onSwitchValueCallback: { [weak self] (id, isFavourite) in
            self?.walletDataProvider.setIsFavourite(id: id, isFavourite: isFavourite)
            self?.tableView.reloadData()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.isSearching
            ? false
            : self.walletDataProvider.getCountSections() == 2 && indexPath.section != 1
                ? true
                : false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.walletDataProvider.swapUsedCurrencies(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension WalletSettingsDisplayManager: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearching = false
            self.tableView.reloadData()
        } else {
            self.isSearching = true
            self.filteredBalances = self.walletDataProvider.getCurrenciesByFilter(filterClosure: { $0.currency.contains(searchText.uppercased()) })
            self.tableView.reloadData()
        }
    }
}
