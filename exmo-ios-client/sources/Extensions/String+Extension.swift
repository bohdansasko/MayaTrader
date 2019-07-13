//
//  String+Extension.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

extension String {
    
    func isDoubleValid() -> Bool {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 10

        formatter.decimalSeparator = "."
        if let _ = formatter.number(from: self) {
            return true
        } else {
            formatter.decimalSeparator = ","
            return formatter.number(from: self) != nil
        }

    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
