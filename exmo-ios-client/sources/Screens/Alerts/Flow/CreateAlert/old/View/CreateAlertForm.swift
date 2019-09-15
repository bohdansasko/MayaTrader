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
    var notes: String?
    var isPersistent: Bool = false
    var onTouchButtonCreate: VoidClosure?
    var cellItems = [FormItem]()
    
    init() {
        // do nothing
    }
    
    func viewIsReady() {
        setupFormItems()
    }
    
    func refreshTitle() {
        title = currencyPair == nil ? "Create alert" : "Update alert"
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
        currencyPairItem.onTextChanged = { [unowned self, weak currencyPairItem] leftValue, rightValue in
            self.currencyPair = leftValue
            currencyPairItem?.leftValue = leftValue
            self.updateCurrenciesPlaceholders()
        }
        currencyPairItem.leftValue = currencyPair
        currencyPairItem.uiProperties.cellType = .currencyDetails
        
        let upperBoundItem = FloatingNumberFormItem(title: "HIGHER VALUE", placeholder1: "0", placeholder2: " USD")
        upperBoundItem.valueCompletion = {
            [weak self, weak upperBoundItem] value in
            self?.topBound = value
            upperBoundItem?.value = value
        }
        upperBoundItem.value = topBound
        upperBoundItem.uiProperties.cellType = .floatingNumberTextField
        
        let bottomBoundItem = FloatingNumberFormItem(title: "LOWER VALUE", placeholder1: "0", placeholder2: " USD")
        bottomBoundItem.valueCompletion = {
            [weak self, weak bottomBoundItem] value in
            self?.bottomBound = value
            bottomBoundItem?.value = value
        }
        bottomBoundItem.value = bottomBound
        bottomBoundItem.uiProperties.cellType = .floatingNumberTextField
        
        let notesItem = TextFormItem(title: "NOTE", placeholder: "Write reminder note...")
        notesItem.onTextChanged = { [unowned self, weak notesItem] value in
            self.notes = value
            notesItem?.value = value
        }
        notesItem.value = notes
        notesItem.uiProperties.cellType = .textField
        
        let buttonItem = ButtonFormItem(title: currencyPair == nil ? "CREATE" : "UPDATE")
        buttonItem.onTouch = onTouchButtonCreate
        buttonItem.uiProperties.cellType = .button
        
        cellItems = [currencyPairItem, upperBoundItem, bottomBoundItem, notesItem, buttonItem]
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

    func clear() {
        cellItems.forEach({ $0.clear() })
        topBound = nil
        bottomBound = nil
        notes = nil
        isPersistent = false

    }
}
