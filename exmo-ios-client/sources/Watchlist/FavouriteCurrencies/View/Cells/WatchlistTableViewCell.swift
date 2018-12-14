//
//  Watchlist.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIColor

protocol WatchlistCell {
    func getIndicatorColor(priceIndicator: Double) -> UIColor
}

extension WatchlistCell {
    func getIndicatorColor(priceIndicator: Double) -> UIColor {
        return priceIndicator > 0 ? .greenBlue : .orangePink
    }
}
