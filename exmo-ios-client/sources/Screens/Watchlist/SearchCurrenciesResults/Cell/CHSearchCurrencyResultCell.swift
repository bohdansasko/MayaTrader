//
//  CHSearchCurrencyResultCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/21/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSearchCurrencyResultCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var stockIcon          : UIImageView!
    @IBOutlet fileprivate weak var stockLabel         : UILabel!
    @IBOutlet fileprivate weak var currencyLabel      : UILabel!
    @IBOutlet fileprivate weak var currencyPriceLabel : UILabel!
    @IBOutlet fileprivate weak var currencyVolumeLabel: UILabel!
    
}

extension CHSearchCurrencyResultCell {
    
    func set(formatter: CHLiteCurrencyFormatter) {
        stockIcon.image          = formatter.stockIcon
        stockLabel.text          = formatter.stockName
        currencyLabel.text       = formatter.currencyName
        currencyPriceLabel.text  = formatter.sellPrice
        currencyVolumeLabel.text = formatter.volume
    }
    
}
