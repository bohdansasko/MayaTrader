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
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 10
        print(self)
        return formatter.number(from: self) != nil
    }
}
