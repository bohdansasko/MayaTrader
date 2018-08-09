//
//  SearchTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class SearchTableViewCell: AlertTableViewCellWithTextData {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var id: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // do nothing
    }
    
    func setContent(currencyPairModel: SearchCurrencyPairModel) {
        self.id = currencyPairModel.id
        self.nameLabel.text = currencyPairModel.getDisplayName()
        self.priceLabel.text = currencyPairModel.getPairPriceAsStr()
    }
    
    func setContent(currencyPairModel: SearchModel) {
        self.id = currencyPairModel.id
        self.nameLabel.text = currencyPairModel.name
        self.priceLabel.isHidden = true
    }

}
