//
// Created by Bogdan Sasko on 1/1/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol IFilterGroupController: class {
    func isCurrencyCodeRelativeToGroup(currencyCode: String, currencyGroupName: String) -> Bool
}

class ExmoFilterGroupController: IFilterGroupController {
    func isCurrencyCodeRelativeToGroup(currencyCode: String, currencyGroupName: String) -> Bool {
        let currenciesContainer = currencyCode.split(separator: "_")
        if currenciesContainer.count < 2 {
            return currencyCode.lowercased() == currencyGroupName.lowercased()
        }
        let groups = currencyGroupName.split(separator: ",")
        for group in groups {
            if group == currenciesContainer[0] || group == currenciesContainer[1] {
                return true
            }
        }
        return false
    }
}