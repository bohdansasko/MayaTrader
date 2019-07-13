//
//  UIStoryboard+Extensions.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit


// MARK: - types/structures/getters

extension UIStoryboard {
    
    enum StoryboardType: String {
        case home      = "Home"
        case watchlist = "CHWatchlist"
        case orders    = "CHOrders"
        case wallet    = "CHWallet"
        case alerts    = "CHAlerts"
        case menu      = "CHMenu"
    }
    
}


// MARK: - initializers

extension UIStoryboard {
    
    convenience init(_ type: StoryboardType, bundle: Bundle = Bundle.main) {
        self.init(name: type.rawValue, bundle: bundle)
    }
    
}
