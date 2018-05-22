//
//  Watchlist.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIColor

protocol WatchlistTableViewCell {
    func getIndicatorColor(priceIndicator: Double) -> UIColor
}

extension WatchlistTableViewCell {
    func getIndicatorColor(priceIndicator: Double) -> UIColor {
        return priceIndicator > 0
            ? UIColor(red: 20/255, green: 219/255, blue: 111/255, alpha: 1.0)
            : UIColor(named: "exmoOrangePink")!
    }
}
