//
//  FormCreateOrderOnSum.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/7/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class FormCreateOrderOnSum: FormTabCreateOrder {
    var title: String?
    var currencyPair: String?
    var amount: String?
    var strPrice: String?
    var orderType: OrderCreateType = .MarketBuy
    var onTouchButtonCreate: VoidClosure?
    var cellItems = [FormItem]()
    
    init() {
        title = "On sum"
    }
    
    func viewIsReady() {
        setupFormItems()
    }
    
    func setTouchEnabled(_ isTouchEnabled: Bool) {
        guard let cellButton = cellItems.last as? ButtonFormItem else { return }
        cellButton.onChangeTouchState?(isTouchEnabled)
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
            self?.strPrice = rightValue
            self?.updateCurrenciesPlaceholders()
        }
        currencyPairItem.leftValue = currencyPair
        currencyPairItem.uiProperties.cellType = .CurrencyDetails
        
        let forAmountItem = FloatingNumberFormItem(title: "For the amount of", placeholder1: "0", placeholder2: " USD")
        forAmountItem.uiProperties.cellType = .FloatingNumberTextField
        
        let amountWillBeItem = FloatingNumberFormItem(title: "The amount will be", placeholder1: "0", placeholder2: " USD")
        amountWillBeItem.uiProperties.isUserInteractionEnabled = false
        amountWillBeItem.uiProperties.cellType = .FloatingNumberTextField
        
        forAmountItem.valueCompletion = {
            [weak self, weak forAmountItem, weak amountWillBeItem] value in
            self?.amount = value
            forAmountItem?.value = value
            self?.updateTotalFormItem(totalItem: amountWillBeItem)
        }
        
        let switchItem = SwitchFormItem(title: "Order type")
        switchItem.onChange = {
            [weak self, weak switchItem] value in
            self?.orderType = value == false ? .MarketBuy : .MarketSell
            switchItem?.value = value
        }
        switchItem.uiProperties.cellType = .Switcher
        
        let buttonItem = ButtonFormItem(title: "CREATE")
        buttonItem.onTouch = onTouchButtonCreate
        buttonItem.uiProperties.cellType = .Button
        
        cellItems = [currencyPairItem, forAmountItem, amountWillBeItem, switchItem, buttonItem]
    }
    
    private func updateTotalFormItem(totalItem: FloatingNumberFormItem?) {
        guard let amount = Double(self.amount ?? ""),
            let price = Double(self.strPrice ?? "") else {
                totalItem?.valueChanged?(nil)
                return
        }
        
        let totalValue = amount * price
        totalItem?.valueChanged?(Utils.getFormatedPrice(value: totalValue, maxFractDigits: 9))
    }
    
    private func updateCurrenciesPlaceholders() {
        guard let splitCurrencyPair = currencyPair?.split(separator: "/"), splitCurrencyPair.count > 1 else { return }
        let firstCurrency = splitCurrencyPair[0]
        let secondCurrency = splitCurrencyPair[1]
        
        guard let amountItem = cellItems[1] as? FloatingNumberFormItem else {
            return
        }
        amountItem.placeholder2 = " " + secondCurrency
        amountItem.refreshPlaceholder?()
        
        guard let totalItem = cellItems[2] as? FloatingNumberFormItem else {
            return
        }
        totalItem.placeholder2 = " " + firstCurrency
        totalItem.refreshPlaceholder?()
    }
}
