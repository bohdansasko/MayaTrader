//
//  WatchlistFlatTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class WatchlistFlatTableViewCell: UITableViewCell, WatchlistTableViewCell {

    @IBOutlet weak var currencyPairNameLabel: UILabel!
    @IBOutlet weak var currencyPairPriceLabel: UILabel!
    @IBOutlet weak var currencyPairIndicatorLabel: UILabel!
    @IBOutlet weak var currencyPairVolumeLabel: UILabel!
    @IBOutlet weak var currencyIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data: WatchlistCurrencyPairModel) {
        self.currencyPairNameLabel.text = data.getPairName()
        self.currencyPairVolumeLabel.text = data.getVolumeStr()
        self.currencyPairPriceLabel.text = data.getPriceAsStr()
        self.currencyPairIndicatorLabel.text = data.getPriceIndicatorAsStr()
        self.currencyPairIndicatorLabel.textColor = self.getIndicatorColor(priceIndicator: data.getPriceIndicator())
        self.currencyIcon.image = data.getIconImage()
    }

}
