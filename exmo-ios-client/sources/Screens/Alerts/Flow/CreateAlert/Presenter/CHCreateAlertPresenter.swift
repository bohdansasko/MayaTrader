//
//  CHCreateAlertPresenter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHCreateAlertPresenter: NSObject {
    fileprivate enum CellId {
        case currency
        case currencyTopValue
        case currencyBottomValue
        case notes
        case cta
    }
    
    fileprivate let tableView: UITableView
    fileprivate let layout: CHCreateAlertLayout
    
    fileprivate let cellsLayout: [IndexPath: CellId] = [
        IndexPath(row: 0, section: 0): .currency,
        IndexPath(row: 1, section: 0): .currencyTopValue,
        IndexPath(row: 2, section: 0): .currencyBottomValue,
        IndexPath(row: 3, section: 0): .notes,
        IndexPath(row: 4, section: 0): .cta
    ]
    private var cells: [IndexPath: UITableViewCell] = [:]
    private var items: [String] = ["", "", "", "", ""]
    
    init(tableView: UITableView, layout: CHCreateAlertLayout) {
        self.tableView = tableView
        self.layout = layout
        
        super.init()
        
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.cellsLayout.forEach{
            let cellType = self.tableViewCellType(for: $0.key)
            if cellType == TextFieldCell.self {
                self.tableView.register(class: cellType)
            } else {
                self.tableView.register(nib: cellType)
            }
        }
    }
    
}

// MARK: - Help methods

private extension CHCreateAlertPresenter {
    
    func tableViewCellType(for indexPath: IndexPath) -> UITableViewCell.Type {
        let cellId = cellsLayout[indexPath]!
        switch cellId {
        case .currency:
            return CHSelectCurrencyCell.self
        case .currencyTopValue:
            return CHNumberCell.self
        case .currencyBottomValue:
            return CHNumberCell.self
        case .notes:
            return TextFieldCell.self
        case .cta:
            return CHButtonCell.self
        }
    }
    
    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let cellId = cellsLayout[indexPath]!
        let updatableCell = cell as! FormUpdatable
        var formItem: FormItem?
        
        switch cellId {
        case .currency:
            let currencyPairItem = CurrencyDetailsItem(title: "Currency pair", placeholder: "Select currency pair…", isMandatory: true)
            currencyPairItem.valueCompletion = {
                [weak self, weak currencyPairItem] leftValue, rightValue in
//                self?.currencyPair = leftValue
//                currencyPairItem?.leftValue = leftValue
//                self?.updateCurrenciesPlaceholders()
            }
//            currencyPairItem.leftValue = currencyPair
            currencyPairItem.uiProperties.cellType = .currencyDetails
            formItem = currencyPairItem
        case .currencyTopValue:
            let upperBoundItem = FloatingNumberFormItem(title: "HIGHER VALUE", placeholder1: "0", placeholder2: " USD")
            upperBoundItem.valueCompletion = {
                [weak self, weak upperBoundItem] value in
//                self?.topBound = value
//                upperBoundItem?.value = value
            }
//            upperBoundItem.value = topBound
            upperBoundItem.uiProperties.cellType = .floatingNumberTextField
            formItem = upperBoundItem
        case .currencyBottomValue:
            let bottomBoundItem = FloatingNumberFormItem(title: "LOWER VALUE", placeholder1: "0", placeholder2: " USD")
            bottomBoundItem.valueCompletion = {
                [weak self, weak bottomBoundItem] value in
//                self?.bottomBound = value
//                bottomBoundItem?.value = value
            }
//            bottomBoundItem.value = bottomBound
            bottomBoundItem.uiProperties.cellType = .floatingNumberTextField
            formItem = bottomBoundItem
        case .notes:
            let descriptionItem = TextFormItem(title: "NOTE", placeholder: "Write reminder note...")
            descriptionItem.valueCompletion = {
                [weak self, weak descriptionItem] value in
//                self?.description = value
                descriptionItem?.value = value
            }
            descriptionItem.value = description
            descriptionItem.uiProperties.cellType = .textField
            formItem = descriptionItem
        case .cta:
            let currencyPair: String? = nil
            let buttonItem = ButtonFormItem(title: currencyPair == nil ? "CREATE" : "UPDATE")
//            buttonItem.onTouch = onTouchButtonCreate
            buttonItem.uiProperties.cellType = .button
            formItem = buttonItem
        }
        updatableCell.update(item: formItem)
    }
    
}

// MARK: - UITableViewDataSource

extension CHCreateAlertPresenter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cells.keys.contains(indexPath) {
            return cells[indexPath]!
        }
        
        let cellType = tableViewCellType(for: indexPath)
        let cell = tableView.dequeue(class: cellType, for: indexPath)
        cells[indexPath] = cell
        self.configure(cell: cell, at: indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CHCreateAlertPresenter: UITableViewDelegate {
    // do nothing
}
