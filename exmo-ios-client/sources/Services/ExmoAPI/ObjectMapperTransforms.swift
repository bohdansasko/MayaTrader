//
//  ObjectMapperTransforms.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import ObjectMapper

// MARK: - StringToDoubleTransform

final class StringToDoubleTransform: TransformType {
    typealias Object = Double
    typealias JSON = String

    static let shared = StringToDoubleTransform()

    func transformFromJSON(_ value: Any?) -> Double? {
        guard let strValue = value as? String else { return nil }
        return Double(strValue)
    }
    
    func transformToJSON(_ value: Double?) -> String? {
        guard let v = value else { return nil }
        return String(v)
    }
    
}
