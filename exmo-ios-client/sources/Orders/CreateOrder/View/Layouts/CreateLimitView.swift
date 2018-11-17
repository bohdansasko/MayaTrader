
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
    weak var output: CreateOrderViewOutput!
    let kCellId = "kCellId"
    let kCellIdMoreVariants = "kCellIdMoreVariants"
    let kCellButtonId = "CellButton"
    let kCellUISwitcherId = "kCellUISwitcher"
    var layoutType: CreateOrderDisplayType = .Limit {
        didSet {
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
        switch (layoutType) {
        case .Limit: return getLimitCell(cellForRowAt: indexPath)
        case .InstantOnAmount: return getInstantOnAmountCell(cellForRowAt: indexPath)
        case .InstantOnSum: return getInstantOnSumCell(cellForRowAt: indexPath)
        }
    }
}

// @MARK: datasource
extension CreateOrderLimitView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        output.openCurrencySearchVC()
    }
}

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

    func getLimitCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func getInstantOnAmountCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func getInstantOnSumCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func getOrderCell(cellForRowAt indexPath: IndexPath, model: ModelOrderViewCell?) -> UITableViewCell {
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
            cell.textForStateOnOff = ["Sell", "Buy"]
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId) as! CellInputField
        cell.model = model
        cell.selectionStyle = .none
        return cell
    }
}
