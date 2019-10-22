//
//  Utils.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/9/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIColor

class Utils {
    private init() { }
    
    static func getFormatedPrice(value: Double, maxFractDigits: Int = 4, isForce: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = isForce
                ? maxFractDigits
                : value > 0.0001
                        ? 4
                        : maxFractDigits
        if let formattedPrice = formatter.string(for: value) {
            return formattedPrice
        }
        return String(value)
    }

    static func getJSONFormattedNumb(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 10
        if let formattedNumb = formatter.string(for: value) {
            return formattedNumb
        }
        return String(value)
    }

    static func getJSONFormattedNumb(from value: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 10

        formatter.decimalSeparator = "."
        if let n = formatter.number(from: value)?.doubleValue {
            return n
        } else {
            formatter.decimalSeparator = ","
            if let n = formatter.number(from: value)?.doubleValue {
                return n
            }
            return 0.0
        }
    }

    static func getDisplayCurrencyPair(rawCurrencyPairName: String) -> String {
        return rawCurrencyPairName.replacingOccurrences(of: "_", with: "/")
    }
    
    static func getRawCurrencyPairName(name: String) -> String {
        return name.replacingOccurrences(of: "/", with: "_")
    }
    
    static func getFormatedCurrencyPairChanges(changesValue: Double) -> String {
        return Utils.getSign(value: changesValue) + Utils.getFormatedPrice(value: abs(changesValue), maxFractDigits: 2, isForce: true) + "%"
    }
    
    static func getSign(value: Double) -> String {
        return value > 0.0
            ? "+"
            : value < 0
                ? "-" : ""
    }
    
    static func getChangesColor(value: Double) -> UIColor {
        return value > 0.0
                ? .greenBlue
                : value < 0.0
                    ? .orangePink
                    : .white
    }
    
    static func getCurrencyIconName(currencyShortName: String) -> String {
        let iconName = "ic_crypto_" + currencyShortName.lowercased()
        return iconName
    }

    @available(*, deprecated, message: "use instead asString in the object `LimitObjects`")
    static func getFormatMaxObjects(_ maxObject: LimitObjects) -> String {
        return "\(String(maxObject.amount))/\(maxObject.max)"
    }
}
