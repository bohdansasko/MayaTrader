//
//  CHCreateAlertHighLowForm.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol CHCreateAlertHighLowFormDelegate: class {
    func createAlertHighLowForm(_ form: CHCreateAlertHighLowForm, didTouch cell: CHCreateAlertHighLowForm.CellId)
}

final class CHCreateAlertHighLowForm: CHBaseForm {
    
    // MARK: - Private variables
    
    enum CellId {
        case currency
        case currencyTopValue
        case currencyBottomValue
        case notes
        case cta
    }
    
    fileprivate let cellsLayout: [IndexPath: CellId] = [
        IndexPath(row: 0, section: 0): .currency,
        IndexPath(row: 1, section: 0): .currencyTopValue,
        IndexPath(row: 2, section: 0): .currencyBottomValue,
        IndexPath(row: 3, section: 0): .notes,
        IndexPath(row: 4, section: 0): .cta
    ]

    fileprivate(set) var selectedCurrency: CHLiteCurrencyModel?
    
    fileprivate(set) var currencyPair: String?
    fileprivate(set) var topBound: String?
    fileprivate(set) var bottomBound: String?
    fileprivate(set) var notes: String?

    // MARK: - Public variables
    
    weak var delegate: CHCreateAlertHighLowFormDelegate?
    
    // MARK: - Lifecycle
    
    override init(tableView: UITableView) {
        super.init(tableView: tableView)
        
        setupTableView()
    }

    func isValid() -> Bool {
        for (_, item) in formItems {
            if !item.isValidate() {
                log.debug("item \(item.title ?? "noname") isn't valid")
                return false
            }
        }
        
        return true
    }
}

// MARK: - Setup

private extension CHCreateAlertHighLowForm {
    
    func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.cellsLayout.forEach{
            let cellType = self.tableViewCellType(for: $0.key)
            self.tableView.register(nib: cellType)
        }
    }
    
}

// MARK: - Setters

extension CHCreateAlertHighLowForm {
    
    func set(currency: CHLiteCurrencyModel) {
        guard
            let currencyIndexPath = cellsLayout.first(where: { $0.value == .currency })?.key,
            let currencyCell = cells[currencyIndexPath] as? FormUpdatable,
            let currencyFormItem = formItems[currencyIndexPath] as? CurrencyDetailsItem else {
                assertionFailure("fix me")
                return
        }
        selectedCurrency = currency
        
        // update currency cell
        
        currencyFormItem.leftValue = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currency.name)
        currencyFormItem.rightValue = Utils.getFormatedPrice(value: currency.sellPrice, maxFractDigits: 10)
        currencyCell.update(item: currencyFormItem)

        // update highest, lowest price value in the number fields
        
        for (_, cell) in cells {
            guard let floatingCell = cell as? CHNumberCell else {
                continue
            }
            floatingCell.formItem?.value = Utils.getFormatedPrice(value: currency.sellPrice, maxFractDigits: 10)
            floatingCell.update(item: floatingCell.formItem)
        }
    }
    
}

// MARK: - Help

private extension CHCreateAlertHighLowForm {
    
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
            return CHTextInputCell.self
        case .cta:
            return CHButtonCell.self
        }
    }
    
    func configure(cell: FormUpdatable, at indexPath: IndexPath) {
        let cellId = cellsLayout[indexPath]!
        let formItem = makeFormItem(by: cellId)
        cell.update(item: formItem)
        formItems[indexPath] = formItem
    }
    
}

// MARK: - Make form items

private extension CHCreateAlertHighLowForm {
    
    func makeFormItem(by cellId: CellId) -> FormItem {
        let formItem: FormItem
        switch cellId {
        case .currency:
            formItem = makeCurrencyFormItem(currencyPair: nil)
        case .currencyTopValue:
            formItem = makeHigherValueFormItem(upperBoundValue: nil)
        case .currencyBottomValue:
            formItem = makeLowerValueFormItem(bottomBoundValue: nil)
        case .notes:
            formItem = makeNotesFormItem(notes: nil)
        case .cta:
            formItem = makeCTAFormItem(onTouch: { [unowned self] in
                self.delegate?.createAlertHighLowForm(self, didTouch: .cta)
            })
        }
        return formItem
    }
    
    func makeCurrencyFormItem(currencyPair: String?) -> FormItem {
        let currencyPairItem = CurrencyDetailsItem(title: "SCREEN_CREATE_ALERT_CURRENCY_PAIR".localized,
                                                   placeholder: "SCREEN_CREATE_ALERT_SELECT_CURRENCY".localized,
                                                   isMandatory: true)
        currencyPairItem.onSelect = { [unowned self] in
            self.delegate?.createAlertHighLowForm(self, didTouch: .currency)
        }
        currencyPairItem.onTextChanged = { [unowned self, weak currencyPairItem] leftValue, rightValue in
            self.currencyPair = leftValue
            currencyPairItem?.leftValue = leftValue
            //            self?.updateCurrenciesPlaceholders()
        }
        currencyPairItem.leftValue = currencyPair
        currencyPairItem.uiProperties.cellType = .currencyDetails
        return currencyPairItem
    }
    
    func makeHigherValueFormItem(upperBoundValue: String?) -> FormItem {
        let upperBoundItem = FloatingNumberFormItem(title: "SCREEN_CREATE_ALERT_HIGH_VALUE".localized, placeholder1: "0", placeholder2: " USD")
        upperBoundItem.valueCompletion = { [unowned self, weak upperBoundItem] value in
            self.topBound = value
            upperBoundItem?.value = value
        }
        upperBoundItem.value = upperBoundValue
        upperBoundItem.uiProperties.cellType = .floatingNumberTextField
        return upperBoundItem
    }
    
    func makeLowerValueFormItem(bottomBoundValue: String?) -> FormItem {
        let bottomBoundItem = FloatingNumberFormItem(title: "SCREEN_CREATE_ALERT_LOW_VALUE".localized, placeholder1: "0", placeholder2: " USD")
        bottomBoundItem.valueCompletion = { [unowned self, weak bottomBoundItem] value in
            self.bottomBound = value
            bottomBoundItem?.value = value
        }
        bottomBoundItem.value = bottomBoundValue
        bottomBoundItem.uiProperties.cellType = .floatingNumberTextField
        return bottomBoundItem
    }
    
    func makeNotesFormItem(notes: String?) -> FormItem {
        let descriptionItem = TextFormItem(title: "SCREEN_CREATE_ALERT_NOTE".localized, placeholder: "SCREEN_CREATE_ALERT_NOTE_PLACEHOLDER".localized)
        descriptionItem.onTextChanged = { [unowned self, weak descriptionItem] value in
            self.notes = value
            descriptionItem?.value = value
        }
        descriptionItem.value = notes
        descriptionItem.uiProperties.cellType = .textField
        return descriptionItem
    }
    
    func makeCTAFormItem(onTouch completion: @escaping (() -> Void)) -> FormItem {
        let currencyPair: String? = nil
        let buttonItem = ButtonFormItem(title: currencyPair == nil ? "SCREEN_CREATE_ALERT_CTA_CREATE".localized : "SCREEN_CREATE_ALERT_CTA_UPDATE".localized)
        buttonItem.onTouch = completion
        buttonItem.uiProperties.cellType = .button
        return buttonItem
    }
    
}

// MARK: - UITableViewDataSource

extension CHCreateAlertHighLowForm: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsLayout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cells.keys.contains(indexPath) {
            return cells[indexPath]!
        }
        
        let cellType = tableViewCellType(for: indexPath)
        let cell = tableView.dequeue(class: cellType, for: indexPath)
        cells[indexPath] = cell
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CHCreateAlertHighLowForm: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let formCell = cell as! FormUpdatable
        self.configure(cell: formCell, at: indexPath)
    }
    
}
