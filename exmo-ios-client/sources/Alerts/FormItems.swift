//
//  FormItem.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol FormItem {
    var title: String? {get set}
    var uiProperties: CellUIProperties {get set}
}

class FloatingNumberFormItem: FormItem {
    var title: String?
    var value: String?
    var placeholder: String?
    var uiProperties = CellUIProperties()
    var valueCompletion: ((String?) -> Void)?
    
    init(title: String?, placeholder: String?) {
        self.title = title
        self.placeholder = placeholder
        uiProperties.height = 70
    }
}

class SwitchFormItem: FormItem {
    typealias OnChange = ((Bool) -> Void)?
    
    var title: String?
    var value: Bool = false
    var uiProperties: CellUIProperties
    var onChange: OnChange
    
    init(title: String?) {
        self.title = title
        uiProperties = SwitchCellUIProperties()
        uiProperties.height = 60
    }
}
