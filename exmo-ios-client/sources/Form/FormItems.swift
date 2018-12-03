//
//  FormItem.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol FormItemValidate {
    var isMandatory: Bool {get set}
    func isValidate() -> Bool
}

protocol FormItem: FormItemValidate {
    var title: String? {get set}
    var uiProperties: CellUIProperties {get set}
}

class ButtonFormItem: FormItem {
    var title: String?
    var uiProperties = CellUIProperties()
    var onTouch: (() -> Void)?
    
    var isMandatory: Bool
    
    init(title: String?) {
        self.title = title
        uiProperties.height = 45
        uiProperties.spacingBetweenRows = 60
        isMandatory = false
    }
    
    func isValidate() -> Bool {
        return true
    }
}

class CurrencyDetailsItem: FormItem {
    var title: String?
    var leftValue: String?
    var rightValue: String?
    var placeholder: String?
    var uiProperties = CellUIProperties()
    var valueCompletion: ((String?) -> Void)?
    var isMandatory: Bool
    
    init(title: String?, placeholder: String?, isMandatory: Bool) {
        self.title = title
        self.placeholder = placeholder
        self.isMandatory = isMandatory
    }
    
    func isValidate() -> Bool {
        if leftValue == nil {
            return isMandatory ? false : true
        }
        
        return leftValue?.isEmpty == false
    }
}


class FloatingNumberFormItem: FormItem {
    var isMandatory: Bool
    var title: String?
    var value: String?
    var placeholder: String?
    var uiProperties = CellUIProperties()
    var valueCompletion: ((String?) -> Void)?
    
    init(title: String?, placeholder: String?) {
        self.title = title
        self.placeholder = placeholder
        uiProperties.keyboardType = .decimalPad
        isMandatory = false
    }
    
    func isValidate() -> Bool {
        if value == nil {
            return isMandatory ? false : true
        }
        
        return value?.isEmpty == false
    }
}

class TextFormItem: FormItem {
    var title: String?
    var value: String?
    var placeholder: String?
    var uiProperties = CellUIProperties()
    var valueCompletion: ((String?) -> Void)?
    
    var isMandatory: Bool
    
    init(title: String?, placeholder: String?) {
        self.title = title
        self.placeholder = placeholder
        uiProperties.keyboardType = .asciiCapable
        uiProperties.textMaxLength = 100
        isMandatory = false
    }
    
    func isValidate() -> Bool {
        if value == nil {
            return isMandatory ? false : true
        }
        
        return true
    }
}

class SwitchFormItem: FormItem {
    typealias OnChange = ((Bool) -> Void)?
    
    var title: String?
    var value: Bool = false
    var uiProperties: CellUIProperties
    var onChange: OnChange
    
    var isMandatory: Bool
    
    init(title: String?) {
        self.title = title
        uiProperties = SwitchCellUIProperties()
        uiProperties.height = 60
        isMandatory = false
    }
    
    func isValidate() -> Bool {
        return true
    }
}
