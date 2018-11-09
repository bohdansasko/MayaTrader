//
//  CandleBarChartShortInfoView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import Charts

//
// @MARK: CandleBarChartShortInfoView
//
class CandleBarChartShortInfoView : UIView {
    @IBOutlet weak var labelOpen : UILabel!
    @IBOutlet weak var labelClosed : UILabel!
    @IBOutlet weak var labelHigh : UILabel!
    @IBOutlet weak var labelLow : UILabel!
    @IBOutlet weak var labelVolume : UILabel!
    @IBOutlet weak var labelDate : UILabel!
    
    var model: ChartCandleModel? = nil {
        didSet {
            if let model = self.model {
                labelOpen.text = Utils.getFormatedPrice(value: model.open, maxFractDigits: 4)
                labelClosed.text = Utils.getFormatedPrice(value: model.close, maxFractDigits: 4)
                labelHigh.text = Utils.getFormatedPrice(value: model.high, maxFractDigits: 4)
                labelLow.text = Utils.getFormatedPrice(value: model.low, maxFractDigits: 4)
                
                volumeValue = model.volume
                date = Date(timeIntervalSince1970: model.timeSince1970InSec)
            }
        }
    }
    
    var volumeValue: Double = 0 {
        didSet {
            labelVolume.text = Utils.getFormatedPrice(value: self.volumeValue, maxFractDigits: 5)
        }
    }
    
    var date: Date? = nil {
        didSet {
            guard let d = self.date else {
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss a"
            self.labelDate.text = dateFormatter.string(from: d)
        }
    }
}