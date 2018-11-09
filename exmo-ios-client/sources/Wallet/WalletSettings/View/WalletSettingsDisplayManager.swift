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
    
    var wallet: WalletModel? {
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
        AppDelegate.session.getUser().walletInfo = wallet!
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
        isSearching = !text.isEmpty
        if isSearching {
            filteredBalances = wallet?.getCurrenciesByFilter(filterClosure: { $0.currency.contains(text.uppercased()) })
        } else {
            filteredBalances = []
        }
        
        tableView.reloadData()
    }
}

extension WalletSettingsDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if isSearching {
            title = filteredBalances.isEmpty ? "NO RESULTS FOUND" : "SEARCH RESULTS"
        } else if let w = wallet, w.getCountSections() == 1 {
            title = "CURRENCIES"
        } else {
            title = section == 0 ? "SELECTED" : "UNUSED"
        }
        
        let headerView = WalletSettingsTableHeaderCell()
        headerView.title = title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let w = wallet else { return 0 }
        return isSearching ? 1 : w.getCountSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let w = wallet else { return 0 }
        
        return isSearching
            ? filteredBalances.count
            : w.getCountSections() == 1
                ? w.getCountAllExistsCurrencies()
                : section == 0
                    ? w.getCountUsedCurrencies()
                    : w.getCountUnusedCurrencies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let w = wallet else { return UITableViewCell() }
        
        let currency = isSearching
            ? filteredBalances[indexPath.row]
            : w.getCurrencyByIndexPath(indexPath: indexPath, numberOfSections: w.getCountSections())
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WalletSettingsTableViewCell
        cell.currency = currency
        cell.onSwitchValueCallback = {
            [weak self] currency in
            self?.wallet?.setIsFavourite(id: currency.orderId, isFavourite: currency.isFavourite)
            self?.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isSearching
            ? false
            : wallet!.getCountSections() == 2 && indexPath.section != 1
                ? true
                : false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        wallet!.swapUsedCurrencies(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
