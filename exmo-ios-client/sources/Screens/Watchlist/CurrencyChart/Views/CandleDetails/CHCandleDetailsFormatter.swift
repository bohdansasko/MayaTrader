
//
//  CHCandleDetailsFormatter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/30/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

final class CHCandleDetailsFormatter {
    let item: CHCandleModel
    
    init(item: CHCandleModel) {
        self.item = item
    }
    
}

// MARK: - Getters

extension CHCandleDetailsFormatter {
    
    var open: String {
        return Utils.getFormatedPrice(value: item.open, maxFractDigits: 10)
    }
    
    var close: String {
        return Utils.getFormatedPrice(value: item.close, maxFractDigits: 10)
    }

    var high: String {
        return Utils.getFormatedPrice(value: item.high, maxFractDigits: 10)
    }

    var low: String {
        return Utils.getFormatedPrice(value: item.low, maxFractDigits: 10)
    }
    
    var volume: String {
        return Utils.getFormatedPrice(value: item.volume)
    }
    
    var date: String {
        let date = Date(timeIntervalSince1970: self.item.timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss a"
        return dateFormatter.string(from: date)
    }
    
}
