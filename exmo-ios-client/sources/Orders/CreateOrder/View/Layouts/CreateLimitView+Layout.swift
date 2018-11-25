//
//  CreateLimitView+Layout.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

extension CreateOrderLimitView {
    func fillFields(number: Double) {
        switch layoutType {
        case .Limit:
            guard let cellAmount = self.getCellByType(inParamType: .Amount) as? CellInputField,
                let cellPrice = self.getCellByType(inParamType: .Price) as? CellInputField else {
                    return
            }
            
            let exmoCommisionInPercentage = 2.0/10
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
    
    func onTouchButtonCreate() {
        guard let currency = selectedCurrency,
            let cellOrderType = getCellByType(inParamType: .OrderType) as? CellUISwitcher,
            let orderType = cellOrderType.datasource as? OrderActionType else {
                return
        }
        switch (layoutType) {
        case .Limit:
            guard let cellAmount = getCellByType(inParamType: .Amount) as? CellInputField,
                let cellPrice = getCellByType(inParamType: .Price) as? CellInputField else {
                    return
            }
            
            let limitOrderType: OrderCreateType = orderType == .Buy ? .Buy : .Sell
            let orderModel = OrderModel(createType: limitOrderType, currencyPair: currency.code, price: cellPrice.getDoubleValue(), quantity: cellAmount.getDoubleValue(), amount: 0)
            parentVC.showLoader()
            output.createOrder(orderModel: orderModel)
            break
        case .InstantOnAmount:
            guard let cellAmount = getCellByType(inParamType: .Amount) as? CellInputField else {
                return
            }
            
            let limitOrderType: OrderCreateType = orderType == .Buy ? .MarketBuy : .MarketSell
            let orderModel = OrderModel(createType: limitOrderType, currencyPair: currency.code, price: 0, quantity: cellAmount.getDoubleValue(), amount: 0)
            output.createOrder(orderModel: orderModel)
            break
        case .InstantOnSum:
            guard let cellAmount = getCellByType(inParamType: .Amount) as? CellInputField else {
                return
            }
            
            let limitOrderType: OrderCreateType = orderType == .Buy ? .MarketBuyTotal : .MarketSellTotal
            let orderModel = OrderModel(createType: limitOrderType, currencyPair: currency.code, price: 0, quantity: cellAmount.getDoubleValue(), amount: 0)
            output.createOrder(orderModel: orderModel)
            break
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
            cell.onTouchButton = {
                [weak self] in
                self?.onTouchButtonCreate()
            }
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
