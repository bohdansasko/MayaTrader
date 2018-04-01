//
//  WatchlistCardCollectionViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/30/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class WatchlistCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var currencyPairFullNameLabel: UILabel!
    @IBOutlet weak var currencyPairPriceLabel: UILabel!
    @IBOutlet weak var currencyPairIndicatorLabel: UILabel!
    
    func setContent(data: WatchlistCurrencyPairModel) {
        self.currencyPairFullNameLabel.text = data.getFullName()
        self.currencyPairPriceLabel.text = data.getPriceAsStr()
        self.currencyPairIndicatorLabel.text = data.getPriceIndicatorAsStr()
    }
}
