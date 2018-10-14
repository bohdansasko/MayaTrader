//
//  Utils.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class Utils {
    private init() {
        // do nothing
    }
    
    static func getFormatedPrice(value: Double, maxFractDigits: Int = 10) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
//        formatter.minimumIntegerDigits = 4
//        formatter.maximumIntegerDigits = 4
        formatter.minimumFractionDigits = 4
        formatter.maximumFractionDigits = maxFractDigits
        if let formattedPrice = formatter.string(for: value) {
            return formattedPrice
        }
        return String(value)
    }

    static func getDisplayCurrencyPair(rawCurrencyPairName: String) -> String {
        return rawCurrencyPairName.replacingOccurrences(of: "_", with: "/")
    }
    
    static func getRawCurrencyPairName(name: String) -> String {
        return name.replacingOccurrences(of: "/", with: "_")
    }
    
    static func getPairChangesInPercentage(currentValue: Double, prevValue: Double) -> Double {
        return (currentValue - prevValue)/prevValue * 100
    }
}
