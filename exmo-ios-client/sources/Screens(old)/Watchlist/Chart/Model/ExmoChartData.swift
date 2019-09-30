//
// Created by Bogdan Sasko on 9/30/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

@available(*, deprecated, message: "remove this file and all included models")
protocol ChartCandleModel {
    var high: Double { get }
    var low: Double { get }
    var open: Double { get }
    var close: Double { get }
    var volume: Double { get }
    var timeSince1970InSec: Double { get }
}

struct DefaultChartCandleModel: ChartCandleModel {
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    var volume: Double
    var timeSince1970InSec: Double
}

struct ProfessionalChartCandleModel: ChartCandleModel, Mappable {
    var high: Double = 0.0
    var low: Double = 0.0
    var open: Double = 0.0
    var close: Double = 0.0
    var volume: Double = 0.0
    var timeSince1970InSec: Double = 0.0

    init?(map: Map) {
        // do nothing
    }

    mutating func mapping(map: Map) {
        high <- map["h"]
        low <- map["l"]
        open <- map["o"]
        close <- map["c"]
        timeSince1970InSec <- map["t"]
        volume <- map["v"]
    }
}

struct CHChartModel {
    enum ParseType {
        case Default
        case Professional
    }
    var candles: [ChartCandleModel] = []

    init(json: JSON = JSON(), parseType: ParseType = .Default) {
        if json["data"].isEmpty {
            return
        }
        
        switch parseType {
        case .Default:
            let jsonPriceModel = json["data"]["price"].arrayValue
            let jsonAmountModel = json["data"]["amount"].arrayValue
            for index in 0..<jsonPriceModel.count {
                let open = jsonPriceModel[index][1].doubleValue
                let high = jsonPriceModel[index][2].doubleValue
                let low = jsonPriceModel[index][3].doubleValue
                let close = jsonPriceModel[index][4].doubleValue
                let timeSince1970InSec = jsonPriceModel[index][0].doubleValue/1000 // NOTE: this needs for get correct date
                let volume = jsonAmountModel[index][1].doubleValue
                
                let newCandle = DefaultChartCandleModel(
                    high: high, low: low,
                    open: open, close: close,
                    volume: volume, timeSince1970InSec: timeSince1970InSec
                )
                candles.append(newCandle)
            }
            case .Professional:
            for jsonValue in json["candles"].arrayValue {
                guard let newCandle = ProfessionalChartCandleModel(JSONString: jsonValue.description) else { continue }
                candles.append(newCandle)
            }
        }
    }
}

extension CHChartModel {
    mutating func saveFirst30Elements() {
        if candles.count > 30 {
            candles.removeLast(candles.count - 30)
        }
    }
    
    func getMinVolume() -> Double {
        guard let candleModel = candles.min(by: { $0.volume < $1.volume }) else {
            return 0.0
        }
        return candleModel.volume
    }
    
    func getMinLow() -> Double {
        guard let candleModel = candles.min(by: { $0.low < $1.low }) else {
            return 0.0
        }
        return candleModel.low
    }
    
    
    func getCandleByIndex(_ index : Int) -> ChartCandleModel? {
        return index > -1 && index < candles.count ? candles[index] : nil
    }
    
    func isEmpty() -> Bool {
        return candles.isEmpty
    }
}
