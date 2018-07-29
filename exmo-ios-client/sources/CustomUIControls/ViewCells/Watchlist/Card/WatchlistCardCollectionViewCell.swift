//
//  WatchlistCardCollectionViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/30/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class WatchlistCardCollectionViewCell: UICollectionViewCell, WatchlistTableViewCell {
    @IBOutlet weak var currencyPairNameLabel: UILabel!
    @IBOutlet weak var currencyPairPriceLabel: UILabel!
    @IBOutlet weak var currencyPairIndicatorLabel: UILabel!
    @IBOutlet weak var currencyIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 5.0
    }
    
    func setContent(data: WatchlistCurrencyPairModel) {
        self.currencyPairNameLabel.text = data.getDisplayCurrencyPairName()
        self.currencyPairPriceLabel.text = data.getPriceAsStr()
        self.currencyPairIndicatorLabel.text = data.getPriceIndicatorAsStr()
        self.currencyPairIndicatorLabel.textColor = self.getIndicatorColor(priceIndicator: data.getPriceIndicator())
        self.currencyIcon.image = data.getIconImage()
    }
}
