//
//  WatchlistFlatTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class WatchlistFlatTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyPairFullNameLabel: UILabel!
    @IBOutlet weak var currencyPairShortNameLabel: UILabel!
    @IBOutlet weak var currencyPairPriceLabel: UILabel!
    @IBOutlet weak var currencyPairIndicatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data: WatchlistCurrencyPairModel) {
        self.currencyPairFullNameLabel.text = data.getFullName()
        self.currencyPairShortNameLabel.text = data.getShortName()
        self.currencyPairPriceLabel.text = data.getPriceAsStr()
        self.currencyPairIndicatorLabel.text = data.getPriceIndicatorAsStr()
    }

}
