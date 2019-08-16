//
//  CHWalletCurrenciesListPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//// MARK: IWalletNetworkWorkerDelegate
//extension WalletCurrenciesListInteractor: IWalletNetworkWorkerDelegate {
//    func onDidLoadWalletSuccessful(_ w: ExmoWallet) {
//        guard let cachedWallet = dbManager.object(type: ExmoUserObject.self, key: "")?.wallet else {
//            return
//        }
//        dbManager.performTransaction {
//            cachedWallet.balances.forEach({
//                cachedCurrency in
//                guard let currency = w.balances.first(where: { $0.code == cachedCurrency.code }) else { return }
//                currency.isFavourite = cachedCurrency.isFavourite
//                currency.orderId = cachedCurrency.orderId
//            })
//        }
//
//        var mutableWallet = w
//        mutableWallet.refresh()
//        output.onDidLoadWallet(mutableWallet)
//    }
//
//    func onDidLoadWalletFail(messageError: String?) {
//        output.onDidLoadWallet(ExmoWallet(id: 0, amountBTC: 0, amountUSD: 0, balances: [], favBalances: [], dislikedBalances: []))
//        print(messageError ?? "Undefined error")
//    }
//}

////////////
final class CHWalletCurrenciesListPresenter: NSObject {
    
    fileprivate let tableView: UITableView
    fileprivate let exmoAPI: CHExmoAPI
    fileprivate let dbManager: OperationsDatabaseProtocol
    
    fileprivate(set) var wallet: ExmoWallet?
    fileprivate var currencies: [Int: [ExmoWalletCurrency]] = [:]
    fileprivate var isSearching = false
    
    init(tableView: UITableView, exmoAPI: CHExmoAPI, dbManager: OperationsDatabaseProtocol) {
        self.tableView = tableView
        self.exmoAPI   = exmoAPI
        self.dbManager = dbManager
        
        super.init()
        
        setupTableView()
    }
    
    func saveToCache(wallet: ExmoWallet) {
        print("wallet was saved to cache")
        print(wallet.favBalances)
        dbManager.add(data: wallet.managedObject(), update: true)
    }
    
}

// MARK: - Setup

private extension CHWalletCurrenciesListPresenter {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        tableView.register(nibForHeaderFooter: CHWalletCurrenciesListHeader.self)
        tableView.register(class: CHWalletCurrenciesListCell.self)
    }
    
}

// MARK: - Database

extension CHWalletCurrenciesListPresenter {
    
    func fetchWallet() {
        if let walletObj = dbManager.object(type: ExmoWalletObject.self, key: "") {
            wallet = ExmoWallet(managedObject: walletObj)
            invalidate()
        }
    }
    
}


// MARK: -
extension CHWalletCurrenciesListPresenter {
    
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
        guard let wallet = wallet else { return }

        currencies.removeAll()
        
        var index = 0
        if wallet.favBalances.count > 0 {
            currencies[0] = wallet.favBalances
            index += 1
        }

        if wallet.dislikedBalances.count > 0 {
            currencies[index] = wallet.dislikedBalances
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

// MARK: - UITableViewDataSource

extension CHWalletCurrenciesListPresenter: UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : currencies.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHWalletCurrenciesListCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let currency = currencies[indexPath.section]?[indexPath.item],
              let wclCell = cell as? CHWalletCurrenciesListCell else {
            return
        }
        
        wclCell.currency = currency
        wclCell.onSwitchValueCallback = {
            [weak self] currency in
            self?.wallet?.setFavourite(currencyCode: currency.code, isFavourite: currency.isFavourite)
            self?.invalidate()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isSearching ? false : true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section >= currencies.count {
            return
        }

        guard let sourceItem = currencies[sourceIndexPath.section]?[sourceIndexPath.item] else {
            return
        }
        if sourceIndexPath.section != destinationIndexPath.section {
            sourceItem.isFavourite = currencies.count == 2 && destinationIndexPath.section == 0
        }
        
        currencies[sourceIndexPath.section]?.remove(at: sourceIndexPath.item)
        currencies[destinationIndexPath.section]?.insert(sourceItem, at: destinationIndexPath.item)
        sourceItem.orderId = destinationIndexPath.row
        
        if let countCurrencies = currencies[0]?.count {
            if countCurrencies == 0 {
                currencies[0] = currencies[1]
                currencies.removeValue(forKey: 1)
            }
        }
        
        if let countCurrencies = currencies[1]?.count {
            if countCurrencies == 0 {
                currencies.removeValue(forKey: 1)
            }
        }
        
        syncWalletWithCurrencies()
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension CHWalletCurrenciesListPresenter: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if isSearching {
            title = currencies.isEmpty ? "NO RESULTS FOUND" : "SEARCH RESULTS"
        } else {
            let isFirstSectionFav = currencies[0]?[0].isFavourite ?? false
            title = isFirstSectionFav && section == 0 ? "FAVOURITE" : "UNUSED"
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withClass: CHWalletCurrenciesListHeader.self)
        headerView.text = title
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

// MARK: - UITableViewDragDelegate

extension CHWalletCurrenciesListPresenter: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let item = currencies[indexPath.section]?[indexPath.row] else { return [] }
        let itemProvider = NSItemProvider(object: item as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
}

// MARK: - UITableViewDropDelegate

extension CHWalletCurrenciesListPresenter: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // do something
    }
    
}
