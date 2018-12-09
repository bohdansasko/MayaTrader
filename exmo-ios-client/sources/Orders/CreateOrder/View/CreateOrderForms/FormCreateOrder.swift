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
        formLimit.onTouchButtonCreate = {
            [weak self, weak formLimit] in
            guard let currencyPair = formLimit?.currencyPair,
                let price = Double(formLimit?.price ?? ""),
                let amount = Double(formLimit?.amount ?? ""),
                let orderType = formLimit?.orderType,
                formLimit?.isValid() == true else {
                    return
            }
            let currencyPairCode = Utils.getRawCurrencyPairName(name: currencyPair)
            let order = OrderModel(createType: orderType, currencyPair: currencyPairCode, price: price, quantity: 0, amount: amount)
            print(order)
        }
        formLimit.viewIsReady()
        
        let formOnAmount = FormCreateOrderOnAmount()
        formOnAmount.onTouchButtonCreate = {
            [weak self, weak formOnAmount] in
            guard let currencyPair = formOnAmount?.currencyPair,
                let amount = Double(formOnAmount?.amount ?? ""),
                let orderType = formOnAmount?.orderType,
                formOnAmount?.isValid() == true else {
                    return
            }
            let currencyPairCode = Utils.getRawCurrencyPairName(name: currencyPair)
            let order = OrderModel(createType: orderType, currencyPair: currencyPairCode, price: 0, quantity: 0, amount: amount)
            print(order)
        }
        formOnAmount.viewIsReady()
        
        let formOnSum = FormCreateOrderOnSum()
        formOnSum.onTouchButtonCreate = {
            [weak self, weak formOnSum] in
            guard let currencyPair = formOnSum?.currencyPair,
                let amount = Double(formOnSum?.amount ?? ""),
                let orderType = formOnSum?.orderType,
                formOnSum?.isValid() == true else {
                    return
            }
            let currencyPairCode = Utils.getRawCurrencyPairName(name: currencyPair)
            let order = OrderModel(createType: orderType, currencyPair: currencyPairCode, price: 0, quantity: 0, amount: amount)
            print(order)
        }
        formOnSum.viewIsReady()
        
        tabs = [formLimit, formOnAmount, formOnSum]
    }
}
