//
//  CreateAlertForm.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class FormCreateAlert {
    var title: String?
    var currencyPair: String?
    var topBound: String?
    var bottomBound: String?
    var note: String?
    var isPersistent: Bool = false
    var onTouchButtonCreate: VoidClosure?
    var cellItems = [FormItem]()
    
    init() {
        title = "Create alert"
    }
    
    func viewIsReady() {
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
        let currencyPairItem = CurrencyDetailsItem(title: "CURRENCY PAIR", placeholder: "Select currency pair…", isMandatory: true)
        currencyPairItem.valueCompletion = {
            [weak self, weak currencyPairItem] value in
            self?.currencyPair = value
            currencyPairItem?.leftValue = value
            self?.updateCurrenciesPlaceholders()
        }
        currencyPairItem.leftValue = currencyPair
        currencyPairItem.uiProperties.cellType = .CurrencyDetails
        
        let upperBoundItem = FloatingNumberFormItem(title: "UPPER BOUND", placeholder1: "0", placeholder2: " USD")
        upperBoundItem.valueCompletion = {
            [weak self, weak upperBoundItem] value in
            self?.topBound = value
            upperBoundItem?.value = value
        }
        upperBoundItem.value = topBound
        upperBoundItem.uiProperties.cellType = .FloatingNumberTextField
        
        let bottomBoundItem = FloatingNumberFormItem(title: "BOTTOM BOUND", placeholder1: "0", placeholder2: " USD")
        bottomBoundItem.valueCompletion = {
            [weak self, weak bottomBoundItem] value in
            self?.bottomBound = value
            bottomBoundItem?.value = value
        }
        bottomBoundItem.value = bottomBound
        bottomBoundItem.uiProperties.cellType = .FloatingNumberTextField
        
        let noteItem = TextFormItem(title: "NOTE", placeholder: "Write reminder note...")
        noteItem.valueCompletion = {
            [weak self, weak noteItem] value in
            self?.note = value
            noteItem?.value = value
        }
        noteItem.value = note
        noteItem.uiProperties.cellType = .TextField
        
        let switchItem = SwitchFormItem(title: "IS PERSISTENT")
        switchItem.onChange = {
            [weak self, weak switchItem] value in
            self?.isPersistent = value
            switchItem?.value = value
        }
        switchItem.value = isPersistent
        switchItem.uiProperties.cellType = .Switcher
        
        let buttonItem = ButtonFormItem(title: currencyPair == nil ? "CREATE" : "UPDATE")
        buttonItem.onTouch = onTouchButtonCreate
        buttonItem.uiProperties.cellType = .Button
        
        cellItems = [currencyPairItem, upperBoundItem, bottomBoundItem, noteItem, switchItem, buttonItem]
    }
    
    private func updateCurrenciesPlaceholders() {
        guard let splitCurrencyPair = currencyPair?.split(separator: "/"), splitCurrencyPair.count > 1 else { return }
        let currency = splitCurrencyPair[1]
        cellItems.forEach({
            item in
            guard let floatingItem = item as? FloatingNumberFormItem else { return }
            floatingItem.placeholder2 = " " + currency
            
        })
    }
}
