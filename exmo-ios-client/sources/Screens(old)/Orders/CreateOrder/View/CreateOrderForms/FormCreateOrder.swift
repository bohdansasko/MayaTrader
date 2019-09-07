//
//  FormCreateOrder.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/7/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol FormCreateOrderDelegate: class {
    func createOrder(_ order: OrderModel)
}

class FormCreateOrder {
    var title: String?
    var tabs = [FormTabCreateOrder]()
    weak var delegate: FormCreateOrderDelegate!
    
    init() {
        title = "Create order"
    }
    
    func viewIsReady() {
        setupFormItems()
    }
    
    func setTouchEnabled(_ isTouchEnabled: Bool) {
        tabs.forEach( { $0.setTouchEnabled(isTouchEnabled) })
    }
    
    private func setupFormItems() {
        let formLimit = FormCreateOrderLimit()
        formLimit.onTouchButtonCreate = {
            [weak self, weak formLimit] in
            guard let currencyPair = formLimit?.currencyPair,
                let price = Double(formLimit?.price ?? ""),
                let quantity = Double(formLimit?.quantity ?? ""),
                let orderType = formLimit?.orderType,
                formLimit?.isValid() == true else {
                    return
            }
            let currencyPairCode = Utils.getRawCurrencyPairName(name: currencyPair)
            let order = OrderModel(createType: orderType, currencyPair: currencyPairCode, price: price, quantity: quantity, amount: 0)
            log.debug(order)
            self?.delegate.createOrder(order)
        }
        formLimit.viewIsReady()
        
        let formOnAmount = FormCreateOrderOnAmount()
        formOnAmount.onTouchButtonCreate = {
            [weak self, weak formOnAmount] in
            guard let currencyPair = formOnAmount?.currencyPair,
                let quantity = Double(formOnAmount?.quantity ?? ""),
                let orderType = formOnAmount?.orderType,
                formOnAmount?.isValid() == true else {
                    return
            }
            let currencyPairCode = Utils.getRawCurrencyPairName(name: currencyPair)
            let order = OrderModel(createType: orderType, currencyPair: currencyPairCode, price: 0, quantity: quantity, amount: 0)
            log.debug(order)
            self?.delegate.createOrder(order)
        }
        formOnAmount.viewIsReady()
        
        let formOnSum = FormCreateOrderOnSum()
        formOnSum.onTouchButtonCreate = {
            [weak self, weak formOnSum] in
            guard let currencyPair = formOnSum?.currencyPair,
                let quantity = Double(formOnSum?.quantity ?? ""),
                let orderType = formOnSum?.orderType,
                formOnSum?.isValid() == true else {
                    return
            }
            let currencyPairCode = Utils.getRawCurrencyPairName(name: currencyPair)
            let order = OrderModel(createType: orderType, currencyPair: currencyPairCode, price: 0, quantity: quantity, amount: 0)
            log.debug(order)
            self?.delegate.createOrder(order)
        }
        formOnSum.viewIsReady()
        
        tabs = [formLimit, formOnAmount, formOnSum]
    }

    func clearForm() {
        tabs.forEach({ $0.clearFields() })
    }
}
