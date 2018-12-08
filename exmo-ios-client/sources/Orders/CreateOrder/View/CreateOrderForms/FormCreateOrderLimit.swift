//
//  FormCreateOrderLimit.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/7/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol FormTabCreateOrder {
    var title: String? { get set }
    var currencyPair: String? { get set }
    var orderType: String? { get set }
    var onTouchButtonCreate: VoidClosure? { get set }
    var cellItems: [FormItem]  { get set }
}

class FormCreateOrderLimit: FormTabCreateOrder {
    var title: String?
    var currencyPair: String?
    var amount: String?
    var price: String?
    var orderType: String?
    var onTouchButtonCreate: VoidClosure?
    var cellItems = [FormItem]()
    
    init() {
        title = "Limit"
        setupFormItems()
    }
    
    func isValid() -> Bool {
        for item in cellItems {
            let vItem = item as FormItemValidate
            if !vItem.isValidate() {
                return false
            }
        }
        
        return true
    }
    
    private func setupFormItems() {
        let currencyPairItem = CurrencyDetailsItem(title: "Currency pair", placeholder: "Select currency pair…", isMandatory: true)
        currencyPairItem.valueCompletion = {
            [weak self, weak currencyPairItem] leftValue, rightValue in
            self?.currencyPair = leftValue
            currencyPairItem?.leftValue = leftValue
            self?.updateCurrenciesPlaceholders()
        }
        currencyPairItem.leftValue = currencyPair
        currencyPairItem.uiProperties.cellType = .CurrencyDetails
        
        let amountItem = FloatingNumberFormItem(title: "Amount", placeholder1: "0", placeholder2: " USD")
        amountItem.uiProperties.cellType = .FloatingNumberTextField

        let priceItem = FloatingNumberFormItem(title: "Price", placeholder1: "0", placeholder2: " USD")
        priceItem.uiProperties.cellType = .FloatingNumberTextField

        let totalItem = FloatingNumberFormItem(title: "Total", placeholder1: "0", placeholder2: " USD")
        totalItem.valueCompletion = {
            [weak totalItem] value in
            totalItem?.value = value
        }
        totalItem.uiProperties.cellType = .FloatingNumberTextField

        let commisionItem = FloatingNumberFormItem(title: "Commision", placeholder1: "0", placeholder2: " USD")
        commisionItem.valueCompletion = {
            [weak commisionItem] value in
            commisionItem?.value = value
        }
        commisionItem.uiProperties.cellType = .FloatingNumberTextField
        
        let switchItem = SwitchFormItem(title: "Order type")
        switchItem.onChange = {
            [weak self, weak switchItem] value in
            self?.orderType = value.description
            switchItem?.value = value
        }
        switchItem.uiProperties.cellType = .Switcher
        
        let buttonItem = ButtonFormItem(title: "CREATE")
        buttonItem.onTouch = onTouchButtonCreate
        buttonItem.uiProperties.cellType = .Button
        
        amountItem.valueCompletion = {
            [weak self, weak amountItem, weak totalItem, weak commisionItem] value in
            self?.amount = value
            amountItem?.value = value
            self?.updateTotalAndComission(totalItem: totalItem, commisionItem: commisionItem)
        }
        
        priceItem.valueCompletion = {
            [weak self, weak priceItem, weak totalItem, weak commisionItem] value in
            self?.price = value
            priceItem?.value = value
            self?.updateTotalAndComission(totalItem: totalItem, commisionItem: commisionItem)
        }
        
        cellItems = [currencyPairItem, amountItem, priceItem, totalItem, commisionItem, switchItem, buttonItem]
    }
    
    private func updateTotalAndComission(totalItem: FloatingNumberFormItem?, commisionItem: FloatingNumberFormItem?) {
        guard let amount = Double(self.amount ?? ""),
            let price = Double(self.price ?? "") else {
                totalItem?.valueChanged?(nil)
                commisionItem?.valueChanged?(nil)
                return
        }
        
        let exmoCommisionInPercentage = 2.0/100
        let totalValue = amount * price
        let comissionValue = (exmoCommisionInPercentage * totalValue)/100.0
        
        totalItem?.valueChanged?(Utils.getFormatedPrice(value: totalValue, maxFractDigits: 9))
        commisionItem?.valueChanged?(Utils.getFormatedPrice(value: comissionValue, maxFractDigits: 9))
    }
    
    private func updateCurrenciesPlaceholders() {
        guard let splitCurrencyPair = currencyPair?.split(separator: "/"), splitCurrencyPair.count > 1 else { return }
        let firstCurrency = splitCurrencyPair[0]
        let secondCurrency = splitCurrencyPair[1]
        
        var placeholderCurrencies = [firstCurrency, secondCurrency, secondCurrency, firstCurrency]
        
        for itemIndex in (1..<cellItems.count - 1) {
            guard let floatingItem = cellItems[itemIndex] as? FloatingNumberFormItem else {
                return
            }
            floatingItem.placeholder2 = " " + placeholderCurrencies[itemIndex - 1]
            floatingItem.refreshPlaceholder?()
        }
    }
}
