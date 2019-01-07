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
    var orderType: OrderCreateType { get set }
    var onTouchButtonCreate: VoidClosure? { get set }
    var cellItems: [FormItem]  { get set }
    
    func setTouchEnabled(_ isTouchEnabled: Bool)
    func clearFields()
}

class FormCreateOrderLimit: FormTabCreateOrder {
    var title: String?
    var currencyPair: String?
    var quantity: String?
    var price: String?
    var orderType: OrderCreateType = .Buy
    var onTouchButtonCreate: VoidClosure?
    var cellItems = [FormItem]()
    
    init() {
        title = "Limit"
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
        price = nil
        orderType = .Buy
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
        totalItem.uiProperties.isUserInteractionEnabled = false
        totalItem.uiProperties.cellType = .FloatingNumberTextField

        let commissionItem = FloatingNumberFormItem(title: "Commission", placeholder1: "0", placeholder2: " USD")
        commissionItem.valueCompletion = {
            [weak commissionItem] value in
            commissionItem?.value = value
        }
        commissionItem.uiProperties.isUserInteractionEnabled = false
        commissionItem.uiProperties.cellType = .FloatingNumberTextField
        
        let segmentItem = SegmentFormItem(title: "Order type", sections: ["Buy", "Sell"])
        segmentItem.onChange = {
            [weak self, weak segmentItem] selectedIndex in
            self?.orderType = selectedIndex == 0 ? .Buy : .Sell
            segmentItem?.value = selectedIndex
        }
        segmentItem.uiProperties.cellType = .Segment
        
        let buttonItem = ButtonFormItem(title: "CREATE")
        buttonItem.onTouch = onTouchButtonCreate
        buttonItem.uiProperties.cellType = .Button
        
        amountItem.valueCompletion = {
            [weak self, weak amountItem, weak totalItem, weak commissionItem] value in
            self?.quantity = value
            amountItem?.value = value
            self?.updateTotalAndComission(totalItem: totalItem, commissionItem: commissionItem)
        }
        
        priceItem.valueCompletion = {
            [weak self, weak priceItem, weak totalItem, weak commissionItem] value in
            self?.price = value
            priceItem?.value = value
            self?.updateTotalAndComission(totalItem: totalItem, commissionItem: commissionItem)
        }
        
        cellItems = [currencyPairItem, amountItem, priceItem, totalItem, commissionItem, segmentItem, buttonItem]
    }
    
    private func updateTotalAndComission(totalItem: FloatingNumberFormItem?, commissionItem: FloatingNumberFormItem?) {
        guard let quantity = Double(self.quantity ?? ""),
            let price = Double(self.price ?? "") else {
                totalItem?.valueChanged?(nil)
                commissionItem?.valueChanged?(nil)
                return
        }
        
        let exmoCommisionInPercentage = 2.0/100
        let totalValue = quantity * price
        let comissionValue = (exmoCommisionInPercentage * totalValue)/100.0
        
        totalItem?.valueChanged?(Utils.getFormatedPrice(value: totalValue, maxFractDigits: 9))
        commissionItem?.valueChanged?(Utils.getFormatedPrice(value: comissionValue, maxFractDigits: 9))
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
