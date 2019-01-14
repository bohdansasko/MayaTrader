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
        
        if formatter.number(from: self) != nil {
            return true
        }
        
        return false
    }
}
