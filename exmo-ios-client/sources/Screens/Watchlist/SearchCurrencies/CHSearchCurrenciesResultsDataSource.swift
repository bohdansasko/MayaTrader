//
//  CHSearchCurrenciesResultsDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/19/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSearchCurrenciesResultsDataSource: CHBaseDataSource<CHLiteCurrencyModel> {
    fileprivate let dbManager    : OperationsDatabaseProtocol
    
    fileprivate var selectedItemsFromDB: Set<CHLiteCurrencyModel> = []
    fileprivate var selectedItems      : Set<CHLiteCurrencyModel> = []
    
    init(dbManager: OperationsDatabaseProtocol) {
        self.dbManager = dbManager
        super.init()
    }
    
    func fetchFavouriteCurrencies() {
        guard let favCurrenciesObj = self.dbManager.objects(type: CHLiteCurrencyModel.self, predicate: nil) else {
            return
        }
        let favCurrencies   = Set(favCurrenciesObj)
        selectedItemsFromDB = favCurrencies
        set(selected: favCurrencies)
    }
    
    func cacheToDatabase() {
        let removedItems     = selectedItemsFromDB.subtracting(selectedItems)
        let newSelectedItems = selectedItems.subtracting(selectedItemsFromDB)
        
        for item in removedItems {
            print("😥 removed item -> ", item)
        }
        
        for item in newSelectedItems {
            print("😃 new added item -> ", item)
        }
        
        DispatchQueue.main.async {
            if !removedItems.isEmpty {
                self.dbManager.delete(data: Array(removedItems))
            }
            
            if !newSelectedItems.isEmpty {
                self.dbManager.add(data: Array(newSelectedItems), update: true)
            }
        }
    }
}


extension CHSearchCurrenciesResultsDataSource {
    
    func add(selected item: CHLiteCurrencyModel) {
        selectedItems.insert(item)
    }
    
    func set(selected items: Set<CHLiteCurrencyModel>) {
        selectedItems = items
    }
    
    func remove(selected item: CHLiteCurrencyModel) {
        guard let index = selectedItems.firstIndex(where: { $0.stockName == item.stockName && $0.name == item.name }) else {
            assertionFailure("required")
            return
        }
        selectedItems.remove(at: index)
    }

    func isItem(selected item: CHLiteCurrencyModel) -> Bool {
        return selectedItems.contains(where: { $0.stockName == item.stockName && $0.name == item.name })
    }
 
}

// MARK: - UITableViewDataSource

extension CHSearchCurrenciesResultsDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHSearchCurrencyResultCell.self, for: indexPath)
        return cell
    }
    
}
