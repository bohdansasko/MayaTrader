//
//  ObjectMapperTransforms.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/4/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import ObjectMapper

// MARK: - TransformOrderType.
// TODO: - maybe we can replace this object on EnumTransform from ObjectMapper framework

final class TransformOrderType: TransformType {
    typealias Object = OrderActionType
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        guard let strValue = value as? String else {
            return nil
        }
        return OrderActionType(rawValue: strValue)
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        guard let value = value else {
            return nil
        }
        return value.rawValue
    }
}

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
