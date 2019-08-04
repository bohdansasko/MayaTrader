//
//  ObjectMapper+extension.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import ObjectMapper

extension Map {
    
    func isJsonValid(by requiredFields: [String]) -> Bool {
        for requiredField in requiredFields {
            if self.JSON[requiredField] == nil { return false }
        }
        return true
    }
    
}
