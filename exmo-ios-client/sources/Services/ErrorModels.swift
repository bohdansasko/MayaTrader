//
// Created by Bogdan Sasko on 3/9/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper

class ExmoResponseResult: Mappable {
    var result = false
    var error: String?

    required init?(map: Map) {
        // do nothing
    }

    func mapping(map: Map) {
        result <- map["result"]
        error <- map["error"]
    }
}

class OrderExmoResponseResult : ExmoResponseResult {
    var id: Int64
    
    required init?(map: Map) {
        self.id = -1
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["order_id"]
    }
}
