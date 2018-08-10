//
//  WatchlistCurrencyPairModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIImage

class WatchlistCurrencyPairModel {
    private var pairName: String
    private var currencyVolumeStr: String
    private var price: Double
    private var priceIndicator: Double
    
    init(pairName: String, currencyVolumeStr: String, price: Double, priceIndicator: Double) {
        self.pairName = pairName
        self.currencyVolumeStr = currencyVolumeStr
        self.price = price
        self.priceIndicator = priceIndicator
    }
    
    func getDisplayCurrencyPairName() -> String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: self.pairName)
    }
    
    func getVolumeStr() -> String {
        return self.currencyVolumeStr
    }
    
    func getPriceAsStr() -> String {
        return "$ " + String(price)
    }
    
    func getPriceIndicatorAsStr() -> String {
        return getSign() + String(abs(priceIndicator)) + "%"
    }
    
    private func getSign() -> String {
        return priceIndicator > 0.0
            ? "+"
            : priceIndicator < 0.0
                ? "-"
                : ""
    }
    
    static func mock() -> WatchlistCurrencyPairModel {
        return WatchlistCurrencyPairModel(pairName: "Test/Test", currencyVolumeStr: "T", price: 0.0, priceIndicator: 0.0)
    }
    
    func getPriceIndicator() -> Double {
        return self.priceIndicator
    }
    
    func getIconImage() -> UIImage? {
        let pairComponents = self.pairName.components(separatedBy: "_")
        if pairComponents.isEmpty {
            return nil
        }
        
        let suffix = pairComponents[0].lowercased()
        let iconName = "icon_" + suffix
        return UIImage(named: iconName)!
    }
}
