//
//  CHPeriod.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/27/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

enum CHPeriod {
    case year
    case month
    case week
    case day
    
    var title: String {
        switch self {
        case .year : return "1Y"
        case .month: return "1M"
        case .week : return "1W"
        case .day  : return "1D"
        }
    }
    
    var asArg: String {
        switch self {
        case .year : return "Y"
        case .month: return "M"
        case .week : return "W"
        case .day  : return "D"
        }
    }
    
}
