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
    
    var cellItems = [FormItem]()
    
    init() {
        title = "Create Order"
        setupFormItems()
    }
    
    private func setupFormItems() {
        let currencyPairItem = FloatingNumberFormItem(title: "Currency pair", placeholder: "Select currency pair…")
        currencyPairItem.valueCompletion = {
            [weak self, weak currencyPairItem] value in
            self?.currencyPair = value
            currencyPairItem?.value = value
        }
        currencyPairItem.uiProperties.cellType = .TextField
        
        let upperBoundItem = FloatingNumberFormItem(title: "Upper Bound", placeholder: "0 USD")
        upperBoundItem.valueCompletion = {
            [weak self, weak upperBoundItem] value in
            self?.topBound = value
            upperBoundItem?.value = value
        }
        upperBoundItem.uiProperties.cellType = .TextField
        
        let bottomBoundItem = FloatingNumberFormItem(title: "Upper Bound", placeholder: "0 USD")
        bottomBoundItem.valueCompletion = {
            [weak self, weak bottomBoundItem] value in
            self?.bottomBound = value
            bottomBoundItem?.value = value
        }
        bottomBoundItem.uiProperties.cellType = .TextField
        
        let noteItem = FloatingNumberFormItem(title: "Bottom Bound", placeholder: "0 USD")
        noteItem.valueCompletion = {
            [weak self, weak noteItem] value in
            self?.bottomBound = value
            noteItem?.value = value
        }
        noteItem.uiProperties.cellType = .TextField
        
        let switchItem = SwitchFormItem(title: "Is persistent")
        switchItem.onChange = {
            [weak self, weak switchItem] value in
            self?.isPersistent = value
            switchItem?.value = value
        }
        switchItem.uiProperties.cellType = .Switcher
        
        cellItems = [currencyPairItem, upperBoundItem, bottomBoundItem, noteItem, switchItem]
    }
}
