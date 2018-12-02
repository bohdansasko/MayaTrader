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
    
    private func setupFormItems() {
        let currencyPairItem = CurrencyDetailsItem(title: "CURRENCY PAIR", placeholder: "Select currency pair…")
        currencyPairItem.valueCompletion = {
            [weak self, weak currencyPairItem] value in
            self?.currencyPair = value
            currencyPairItem?.leftValue = value
        }
        currencyPairItem.uiProperties.cellType = .CurrencyDetails
        
        let upperBoundItem = FloatingNumberFormItem(title: "UPPER BOUND", placeholder: "0 USD")
        upperBoundItem.valueCompletion = {
            [weak self, weak upperBoundItem] value in
            self?.topBound = value
            upperBoundItem?.value = value
        }
        upperBoundItem.uiProperties.cellType = .FloatingNumberTextField
        
        let bottomBoundItem = FloatingNumberFormItem(title: "BOTTOM BOUND", placeholder: "0 USD")
        bottomBoundItem.valueCompletion = {
            [weak self, weak bottomBoundItem] value in
            self?.bottomBound = value
            bottomBoundItem?.value = value
        }
        bottomBoundItem.uiProperties.cellType = .FloatingNumberTextField
        
        let noteItem = TextFormItem(title: "NOTE", placeholder: "Write reminder note...")
        noteItem.valueCompletion = {
            [weak self, weak noteItem] value in
            self?.note = value
            noteItem?.value = value
        }
        noteItem.uiProperties.cellType = .TextField
        
        let switchItem = SwitchFormItem(title: "IS PERSISTENT")
        switchItem.onChange = {
            [weak self, weak switchItem] value in
            self?.isPersistent = value
            switchItem?.value = value
        }
        switchItem.uiProperties.cellType = .Switcher
        
        let buttonItem = ButtonFormItem(title: "CREATE")
        buttonItem.onTouch = onTouchButtonCreate
        buttonItem.uiProperties.cellType = .Button
        
        cellItems = [currencyPairItem, upperBoundItem, bottomBoundItem, noteItem, switchItem, buttonItem]
    }
}
