//
//  FormCreateOrder.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/7/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class FormCreateOrder {
    var title: String?
    var tabs = [FormTabCreateOrder]()
    
    init() {
        title = "Create order"
    }
    
    func viewIsReady() {
        setupFormItems()
    }
    
    func isValid() -> Bool {
//        for item in cellItems {
//            let vItem = item as FormItemValidate
//            if !vItem.isValidate() {
//                return false
//            }
//        }
        
        return true
    }
    
    private func setupFormItems() {
        let formLimit = FormCreateOrderLimit()
        let formOnAmount = FormCreateOrderOnAmount()
        let formOnSum = FormCreateOrderOnSum()
        
        tabs = [formLimit, formOnAmount, formOnSum]
    }
}
