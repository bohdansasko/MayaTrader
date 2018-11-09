//
//  WalletSettingsDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UITableView

class WalletSettingsDisplayManager: UIView {
    var tableView: UITableView = {
        let tv = UITableView()
        tv.setEditing(true, animated: true)
        tv.tableFooterView = UIView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()
    
    var walletDataProvider: WalletModel? {
        didSet {
            tableView.reloadData()
        }
    }
    private var filteredBalances: [WalletCurrencyModel]!
    private let cellId = "cellId"
    private var isSearching = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filteredBalances = []
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func saveChangesToSession() {
        AppDelegate.session.getUser().walletInfo = walletDataProvider!
    }
}

extension WalletSettingsDisplayManager {
    func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WalletSettingsTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func filterBy(text: String) {
        
    }
}

extension WalletSettingsDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = WalletSettingsTableHeaderCell()
        headerView.title = "NO RESULTS FOUND"
//            isSearching
//            ? filteredBalances.isEmpty ? "NO RESULTS FOUND" : "SEARCH RESULTS"
//            : walletDataProvider!.getCountSections() == 1
//            ? ""
//            : section == 0 ? "SELECTED" : "UNUSED"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : walletDataProvider!.getCountSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching
            ? filteredBalances.count
            : walletDataProvider!.getCountSections() == 1
                ? walletDataProvider!.getCountAllExistsCurrencies()
                : section == 0
                    ? walletDataProvider!.getCountUsedCurrencies()
                    : walletDataProvider!.getCountUnusedCurrencies()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = isSearching
            ? filteredBalances[indexPath.row]
            : walletDataProvider!.getCurrencyByIndexPath(indexPath: indexPath, numberOfSections: walletDataProvider!.getCountSections())
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WalletSettingsTableViewCell
        cell.currency = currency
        cell.onSwitchValueCallback = {
            [weak self] currency in
            self?.walletDataProvider!.setIsFavourite(id: currency.orderId, isFavourite: currency.isFavourite)
            self?.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isSearching
            ? false
            : walletDataProvider!.getCountSections() == 2 && indexPath.section != 1
                ? true
                : false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        walletDataProvider!.swapUsedCurrencies(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//extension WalletSettingsDisplayManager: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            isSearching = false
//            tableView.reloadData()
//        } else {
//            isSearching = true
//            filteredBalances = walletDataProvider.getCurrenciesByFilter(filterClosure: { $0.currency.contains(searchText.uppercased()) })
//            tableView.reloadData()
//        }
//    }
//}
