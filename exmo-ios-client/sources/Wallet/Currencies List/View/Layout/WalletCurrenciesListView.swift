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
    
    var wallet: ExmoWallet?
    private var currencies: [Int: [ExmoWalletCurrency]] = [:]
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
            currencies[0] = wallet?.filter({ $0.code.contains(text.uppercased()) }) ?? []
            tableView.reloadData()
        } else {
            invalidate()
        }
    }
    
    func invalidate() {
        guard let w = wallet else { return }
        
        var index = 0
        if w.favBalances.count > 0 {
            currencies[index] = w.favBalances
            index = index + 1
        }
        
        if w.dislikedBalances.count > 0 {
            currencies[index] = w.dislikedBalances
        }
        
        if !isSearching {
            syncWalletWithCurrencies()
            tableView.reloadData()
        }
    }
    
    private func syncWalletWithCurrencies() {
        if currencies.count == 2 {
            wallet?.favBalances = currencies[0] ?? []
            wallet?.dislikedBalances = currencies[1] ?? []
        } else if currencies.count == 1 {
            let isFavouriteCurrencies = currencies[0]?[0].isFavourite ?? false
            if isFavouriteCurrencies {
                wallet?.favBalances = currencies[0] ?? []
                wallet?.dislikedBalances = []
            } else {
                wallet?.dislikedBalances = currencies[0] ?? []
                wallet?.favBalances = []
            }
        }
    }
}

// @MARK: UITableViewDataSource
extension WalletCurrenciesListView: UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : currencies.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let currency = currencies[indexPath.section]?[indexPath.item] else { return }
        let wclCell = cell as! WalletCurrenciesListTableViewCell
        wclCell.currency = currency
        wclCell.onSwitchValueCallback = {
            [weak self] currency in
            self?.wallet?.setFavourite(currencyCode: currency.code, isFavourite: currency.isFavourite)
            self?.invalidate()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        print("can move row at")
        return isSearching ? false : true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceItem = currencies[sourceIndexPath.section]?[sourceIndexPath.item] else {
            return
        }
        sourceItem.isFavourite = currencies.count == 2 && destinationIndexPath.section == 0
        currencies[sourceIndexPath.section]?.remove(at: sourceIndexPath.item)
        currencies[destinationIndexPath.section]?.insert(sourceItem, at: destinationIndexPath.item)
        
        sourceItem.orderId = destinationIndexPath.row
        
        syncWalletWithCurrencies()
        tableView.reloadData()
    }
}

// @MARK: UITableViewDelegate
extension WalletCurrenciesListView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if isSearching {
            title = currencies.isEmpty ? "NO RESULTS FOUND" : "SEARCH RESULTS"
        } else {
            let isFirstSectionFav = currencies[0]?[0].isFavourite ?? false
            title = isFirstSectionFav && section == 0 ? "FAVOURITE" : "UNUSED"
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
        guard let item = currencies[indexPath.section]?[indexPath.row] else { return [] }
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
