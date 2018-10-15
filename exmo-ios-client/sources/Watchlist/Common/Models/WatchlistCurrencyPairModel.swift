//
//  WatchlistCurrencyModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct WatchlistCurrencyModel {
    let pairName: String
    let buyPrice: Double
    let timeUpdataInSecFrom1970: Double
    let closeBuyPrice: Double
    let volume: Double
    let volumeCurrency: Double
    
    func getDisplayCurrencyPairName() -> String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: self.pairName)
    }
    
    func getPriceAsStr() -> String {
        return "$ " + String(buyPrice)
    }
    
    func getChanges() -> Double {
        return Utils.getPairChangesInPercentage(currentValue: buyPrice, prevValue: closeBuyPrice)
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
