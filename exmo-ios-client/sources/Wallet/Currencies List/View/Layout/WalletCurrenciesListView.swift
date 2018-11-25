//
//  WalletCurrenciesListView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UITableView

class WalletCurrenciesListView: UIView {
    var tableView: UITableView = {
        let tv = UITableView()
        tv.allowsSelection = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.dragInteractionEnabled = true
        tv.tableFooterView = UIView()
        return tv
    }()
    
    var wallet: ExmoWallet? {
        didSet {
            tableView.reloadData()
        }
    }
    private var filteredCurrencies: [ExmoWalletCurrencyModel] = []
    private let cellId = "cellId"
    private var isSearching = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension WalletCurrenciesListView {
    func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.register(WalletCurrenciesListTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func filterBy(text: String) {
        isSearching = !text.isEmpty
        
        if isSearching {
            filteredCurrencies = wallet?.filter({ $0.code.contains(text.uppercased()) }) ?? []
        } else {
            filteredCurrencies = []
        }
        tableView.reloadData()
    }
}

// @MARK: UITableViewDataSource
extension WalletCurrenciesListView: UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let w = wallet else { return 0 }
        return isSearching ? 1 : w.getCountSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let w = wallet else { return 0 }

        return isSearching
            ? filteredCurrencies.count
            : w.isAllCurrenciesFav()
                ? w.balances.count
                : section == 0
                    ? w.favBalances.count
                    : section == 1 ? w.dislikedBalances.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let w = wallet else { return UITableViewCell() }

        let currency = isSearching
            ? filteredCurrencies[indexPath.row]
            : w.isAllCurrenciesFav()
                ? w.balances[indexPath.row]
                : indexPath.section == 0
                    ? w.favBalances[indexPath.row]
                    : indexPath.section == 1
                        ? w.dislikedBalances[indexPath.row]
                        : ExmoWalletCurrencyModel()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WalletCurrenciesListTableViewCell
        cell.currency = currency
        cell.onSwitchValueCallback = {
            [weak self] currency in
            self?.wallet?.setFavourite(orderId: currency.orderId, isFavourite: currency.isFavourite)
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
        wallet?.swapByIndex(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

// @MARK: UITableViewDelegate
extension WalletCurrenciesListView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if isSearching {
            title = filteredCurrencies.isEmpty ? "NO RESULTS FOUND" : "SEARCH RESULTS"
        } else if let w = wallet, w.getCountSections() == 1 {
            title = "CURRENCIES"
        } else {
            title = section == 0 ? "SELECTED" : "UNUSED"
        }
        
        let headerView = WalletCurrenciesListTableHeaderCell()
        headerView.title = title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// @MARK: UITableViewDragDelegate
extension WalletCurrenciesListView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let w = wallet, isSearching == false else { return [] }
        
        let item = w.isAllCurrenciesFav()
            ? w.balances[indexPath.row]
            : indexPath.section == 0
                ? w.favBalances[indexPath.row]
                : indexPath.section == 1
                    ? w.dislikedBalances[indexPath.row]
                    : ExmoWalletCurrencyModel()
        
        let itemProvider = NSItemProvider(object: item as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

// @MARK: UITableViewDropDelegate
extension WalletCurrenciesListView: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // do something
    }
}
