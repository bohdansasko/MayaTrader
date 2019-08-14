//
// Created by Bogdan Sasko on 3/9/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper

struct ExmoResponseResult: Mappable {
    var result = false
    var error: String?

    init?(map: Map) {
        // do nothing
    }

    mutating func mapping(map: Map) {
        result <- map["result"]
        error <- map["error"]
    }
}

struct OrderExmoResponseResult: Mappable {
    var id: Int64
    var base: ExmoResponseResult
    
    init?(map: Map) {
        guard let baseResponse = ExmoResponseResult(map: map) else {
            return nil
        }
        self.id = 0
        self.base = baseResponse
    }
    
    mutating func mapping(map: Map) {
        base.mapping(map: map)
        id <- map["order_id"]
    }
}
