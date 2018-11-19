
//
//  CreateOrderLimitView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/13/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class CreateOrderLimitView: UIView {
    enum CellType: Int {
        case CurrencyPair
        case Amount
        case Price
        case Total
        case Commision
        case OrderType
        case ButtonCreate
    }
    
    var orderType: OrderActionType = .Sell {
        didSet {
            guard let currency = selectedCurrency else {
                updateSelectedCurrency(name: "", price: 0)
                return
            }
            let price = orderType == .Buy ? currency.buyPrice : currency.sellPrice
            updateSelectedCurrency(name: currency.code, price: price)
        }
    }
    
    weak var output: CreateOrderViewOutput!
    var selectedCurrency: TickerCurrencyModel? {
        didSet {
            print("did set selectedCurrency")
            guard let currency = selectedCurrency else {
                updateSelectedCurrency(name: "", price: 0)
                return
            }
            let price = orderType == .Buy ? currency.buyPrice : currency.sellPrice
            updateSelectedCurrency(name: currency.code, price: price)
        }
    }
    let kCellId = "kCellId"
    let kCellIdMoreVariants = "kCellIdMoreVariants"
    let kCellButtonId = "CellButton"
    let kCellUISwitcherId = "kCellUISwitcher"
    
    var layoutType: CreateOrderDisplayType = .Limit {
        didSet {
            cells.removeAll()
            orderType = .Sell
            updateLayout(layoutType)
        }
    }
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        return tv
    }()
    var cells: [IndexPath: ExmoTableViewCell?] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CellInputField.self, forCellReuseIdentifier: kCellId)
        tableView.register(CellMoreVariantsField.self, forCellReuseIdentifier: kCellIdMoreVariants)
        tableView.register(CellButton.self, forCellReuseIdentifier: kCellButtonId)
        tableView.register(CellUISwitcher.self, forCellReuseIdentifier: kCellUISwitcherId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CreateOrderLimitView {
    func updateLayout(_ layoutType: CreateOrderDisplayType) {
        tableView.reloadData()
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        fillFields(number: 0)
        guard let cell = tableView.cellForRow(at: IndexPath(row: getSelectCurrencyIndexCell(), section: 0)) as? CellMoreVariantsField else { return }
        
        var model = ModelOrderViewCell(headerText: "Currency pair", placeholderText: "Select currency pair...", currencyName: name, rightText: String(price))
        model.isTextInputEnabled = false
        cell.model = model
    }
}

// @MARK: datasource
extension CreateOrderLimitView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfRowsInTab()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = nil
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section+1 == numberOfRowsInTab() ? 45 : 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cells[indexPath] != nil {
            return cells[indexPath]! ?? UITableViewCell()
        }
        switch (layoutType) {
        case .Limit: cells[indexPath] = getLimitCell(cellForRowAt: indexPath)
        case .InstantOnAmount: cells[indexPath] = getInstantOnAmountCell(cellForRowAt: indexPath)
        case .InstantOnSum: cells[indexPath] = getInstantOnSumCell(cellForRowAt: indexPath)
        }
        return cells[indexPath]!!
    }
}

// @MARK: UITableViewDelegate
extension CreateOrderLimitView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == getSelectCurrencyIndexCell() {
            output.openCurrencySearchVC()
        }
    }
}

extension CreateOrderLimitView {
    fileprivate func fillFields(number: Double) {
        switch layoutType {
        case .Limit:
            guard let cellAmount = self.getCellByType(inParamType: .Amount) as? CellInputField,
                  let cellPrice = self.getCellByType(inParamType: .Price) as? CellInputField else {
                    return
            }
            
            let exmoCommisionInPercentage = 2.0
            let price = cellPrice.getDoubleValue()
            let amount = cellAmount.getDoubleValue()
            
            let totalValue = amount * price
            let comissionValue = (exmoCommisionInPercentage * totalValue)/100.0
            
            guard let cellTotal = self.getCellByType(inParamType: .Total) as? CellInputField,
                let cellCommision = self.getCellByType(inParamType: .Commision) as? CellInputField else {
                    return
            }
            cellTotal.datasource = totalValue
            cellCommision.datasource = comissionValue
        case .InstantOnAmount, .InstantOnSum:
            guard let cellAmount = self.getCellByType(inParamType: .Amount) as? CellInputField,
                  let cellTotal = self.getCellByType(inParamType: .Total) as? CellInputField,
                  let selectedCurrency = self.selectedCurrency else {
                    return
            }
            
            let totalValue = cellAmount.getDoubleValue() * (orderType == .Buy ? selectedCurrency.buyPrice : selectedCurrency.sellPrice)
            cellTotal.datasource = totalValue
        }
    }
}
// @MARK: layout
extension CreateOrderLimitView {
    func numberOfRowsInTab() -> Int {
        switch (layoutType) {
        case .Limit: return 7
        case .InstantOnAmount, .InstantOnSum: return 5
        }
    }
    
    func getSelectCurrencyIndexCell() -> Int {
        return 0
    }
    
    func getTotalCellIndex() -> Int {
        switch (layoutType) {
        case .Limit: return 3
        case .InstantOnAmount, .InstantOnSum: return 2
        }
    }
        
    func getCellIndexButtonCreate() -> Int {
        switch (layoutType) {
        case .Limit: return 6
        case .InstantOnAmount, .InstantOnSum: return 4
        }
    }
    
    func getCellIndexOrderCreate() -> Int {
        switch (layoutType) {
        case .Limit: return 5
        case .InstantOnAmount, .InstantOnSum: return 3
        }
    }
}

extension CreateOrderLimitView {
    func getOrderCell(cellForRowAt indexPath: IndexPath, model: ModelOrderViewCell?) -> ExmoTableViewCell {
        if indexPath.section == getSelectCurrencyIndexCell() {
            let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdMoreVariants) as! CellMoreVariantsField
            cell.model = model
            cell.selectionStyle = .gray
            return cell
        } else if indexPath.section == getCellIndexButtonCreate() {
            let cell = tableView.dequeueReusableCell(withIdentifier: kCellButtonId) as! CellButton
            cell.model = model
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == getCellIndexOrderCreate() {
            let cell = tableView.dequeueReusableCell(withIdentifier: kCellUISwitcherId) as! CellUISwitcher
            cell.model = model
            cell.datasource = orderType
            cell.selectionStyle = .none
            cell.onStateChanged = {
                [weak self] datasource in
                guard let orderType = datasource as? OrderActionType else { return }
                self?.orderType = orderType
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId) as! CellInputField
        cell.model = model
        cell.onTextChanged = {
            [weak self] in
            self?.fillFields(number: 1)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func getCellByType(inParamType: CellType) -> ExmoTableViewCell? {
        var itemIndex = -1
        switch inParamType {
        case .CurrencyPair: itemIndex = getSelectCurrencyIndexCell()
        case .Amount: itemIndex = 1
        case .Price: itemIndex = 2
        case .Total: itemIndex = getTotalCellIndex()
        case .OrderType: itemIndex = getCellIndexOrderCreate()
        case .Commision: itemIndex = 4
        default: break
        }
        guard let cell = cells[IndexPath(row: 0, section: itemIndex)] else {
            print("getCellByType: cell with section index \(itemIndex) doesn't exists")
            return nil
        }
        
        return cell
    }
    
    func getLimitCell(cellForRowAt indexPath: IndexPath) -> ExmoTableViewCell {
        var model: ModelOrderViewCell?
        
        switch (indexPath.section) {
        case 0:
            model = ModelOrderViewCell(headerText: "Currency pair", placeholderText: "Select currency pair...")
            model?.isTextInputEnabled = false
        case 1: model = ModelOrderViewCell(headerText: "Amount", placeholderText: "0 BTC")
        case 2: model = ModelOrderViewCell(headerText: "Price", placeholderText: "0 USD")
        case 3:
            model = ModelOrderViewCell(headerText: "Total", placeholderText: "0 USD")
            model?.isTextInputEnabled = false
        case 4:
            model = ModelOrderViewCell(headerText: "Commision", placeholderText: "0 BTC")
            model?.isTextInputEnabled = false
        case 5: model = ModelOrderViewCell(headerText: "Order Type")
        case 6: model = ModelOrderViewCell(headerText: "Create")
        default: break
        }
        
        return getOrderCell(cellForRowAt: indexPath, model: model)
    }
    
    func getInstantOnAmountCell(cellForRowAt indexPath: IndexPath) -> ExmoTableViewCell {
        var model: ModelOrderViewCell?
        
        switch (indexPath.section) {
        case 0:
            model = ModelOrderViewCell(headerText: "Currency pair", placeholderText: "Select currency pair...")
            model?.isTextInputEnabled = false
        case 1: model = ModelOrderViewCell(headerText: "Amount", placeholderText: "0 BTC")
        case 2:
            model = ModelOrderViewCell(headerText: "Total", placeholderText: "0 USD")
            model?.isTextInputEnabled = false
        case 3: model = ModelOrderViewCell(headerText: "Order Type")
        case 4: model = ModelOrderViewCell(headerText: "Create")
        default: break
        }
        
        return getOrderCell(cellForRowAt: indexPath, model: model)
    }
    
    func getInstantOnSumCell(cellForRowAt indexPath: IndexPath) -> ExmoTableViewCell {
        var model: ModelOrderViewCell?
        
        switch (indexPath.section) {
        case 0:
            model = ModelOrderViewCell(headerText: "Currency pair", placeholderText: "Select currency pair...")
            model?.isTextInputEnabled = false
        case 1: model = ModelOrderViewCell(headerText: "For the amount of", placeholderText: "0 BTC")
        case 2:
            model = ModelOrderViewCell(headerText: "The amount will be", placeholderText: "0 USD")
            model?.isTextInputEnabled = false
        case 3: model = ModelOrderViewCell(headerText: "Order Type")
        case 4: model = ModelOrderViewCell(headerText: "Create")
        default: break
        }
        
        return getOrderCell(cellForRowAt: indexPath, model: model)
    }
}
