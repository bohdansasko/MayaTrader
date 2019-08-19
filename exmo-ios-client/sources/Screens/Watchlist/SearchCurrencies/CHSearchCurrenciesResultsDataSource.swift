//
//  CHSearchCurrenciesResultsDataSource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/19/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSearchCurrenciesResultsDataSource: CHBaseDataSource<CHLiteCurrencyModel> {
    fileprivate var selectedItems: Set<CHLiteCurrencyModel> = []
    
    override init() {
        super.init()
    }
    
    func reset() {
        set([])
        selectedItems = []
    }
    
}


extension CHSearchCurrenciesResultsDataSource {
    
    func isItem(selected item: CHLiteCurrencyModel) -> Bool {
        return selectedItems.contains(item)
    }
    
    func remove(selected item: CHLiteCurrencyModel) {
        selectedItems.remove(item)
    }
    
    func add(selected item: CHLiteCurrencyModel) {
        selectedItems.insert(item)
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
