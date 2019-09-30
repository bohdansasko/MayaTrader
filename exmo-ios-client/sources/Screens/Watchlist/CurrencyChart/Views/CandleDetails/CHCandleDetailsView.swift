//
//  CHCandleDetailsView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/26/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHCandleDetailsView: UIView {

    // MARK: - Outlets
    
    @IBOutlet fileprivate weak var dateLabel       : UILabel!
    @IBOutlet fileprivate weak var openValueLabel  : UILabel!
    @IBOutlet fileprivate weak var closedValueLabel: UILabel!
    @IBOutlet fileprivate weak var highValueLabel  : UILabel!
    @IBOutlet fileprivate weak var lowValueLabel   : UILabel!
    @IBOutlet fileprivate weak var volumeValueLabel: UILabel!
    
}

// MARK: - Setters

extension CHCandleDetailsView {

    func set(formatter: CHCandleDetailsFormatter) {
        openValueLabel.text   = formatter.open
        closedValueLabel.text = formatter.close
        highValueLabel.text   = formatter.high
        lowValueLabel.text    = formatter.low
        volumeValueLabel.text = formatter.volume
        dateLabel.text        = formatter.date
    }
    
}
