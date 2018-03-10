//
// Created by Bogdan Sasko on 3/9/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper

class RequestError: Mappable {
    var result = false
    var error: String?

    required init?(map: Map) {
        if map.JSON["error"] == nil {
            return nil
        }
    }

    func mapping(map: Map) {
        result <- map["result"]
        error <- map["error"]
    }
}