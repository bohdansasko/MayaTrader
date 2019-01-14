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
    var quantity: String?
    var strPrice: String?
    var orderType: OrderCreateType = .marketBuy
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

    func clearFields() {
        cellItems.forEach({ $0.clear() })
        currencyPair = nil
        quantity = nil
        strPrice = nil
        orderType = .marketBuy
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
        currencyPairItem.uiProperties.cellType = .currencyDetails
        
        let forAmountItem = FloatingNumberFormItem(title: "For the amount of", placeholder1: "0", placeholder2: " USD")
        forAmountItem.uiProperties.cellType = .floatingNumberTextField
        
        let amountWillBeItem = FloatingNumberFormItem(title: "The amount will be", placeholder1: "0", placeholder2: " USD")
        amountWillBeItem.uiProperties.isUserInteractionEnabled = false
        amountWillBeItem.uiProperties.cellType = .floatingNumberTextField
        
        forAmountItem.valueCompletion = {
            [weak self, weak forAmountItem, weak amountWillBeItem] value in
            self?.quantity = value
            forAmountItem?.value = value
            self?.updateTotalFormItem(totalItem: amountWillBeItem)
        }

        let segmentItem = SegmentFormItem(title: "Order type", sections: ["Buy", "Sell"])
        segmentItem.onChange = {
            [weak self, weak segmentItem] selectedIndex in
            self?.orderType = selectedIndex == 0 ? .marketBuy : .marketSell
            segmentItem?.value = selectedIndex
        }
        segmentItem.uiProperties.cellType = .segment
        
        let buttonItem = ButtonFormItem(title: "CREATE")
        buttonItem.onTouch = onTouchButtonCreate
        buttonItem.uiProperties.cellType = .button
        
        cellItems = [currencyPairItem, forAmountItem, amountWillBeItem, segmentItem, buttonItem]
    }
    
    private func updateTotalFormItem(totalItem: FloatingNumberFormItem?) {
        guard let quantity = Double(self.quantity ?? ""),
            let price = Double(self.strPrice ?? "") else {
                totalItem?.valueChanged?(nil)
                return
        }
        
        let totalValue = quantity * price
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
