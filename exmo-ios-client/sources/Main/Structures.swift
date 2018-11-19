//
//  Structures.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

import SwiftyJSON
import ObjectMapper

struct Ticker: Mappable {
    var pairs: [String: TickerCurrencyModel?] = [:]
    
    init?(map: Map) {
        pairs = [:]
        for (key, value) in map.JSON {
            guard let json = value as? JSON else { continue }
            if var model = TickerCurrencyModel(JSONString: json.description) {
                model.code = key
                pairs[key] = model
            }
        }
    }
    
    mutating func mapping(map: Map) {
        // do nothing
    }
}