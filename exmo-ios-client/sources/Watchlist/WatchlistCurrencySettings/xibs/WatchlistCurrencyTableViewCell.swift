//
//  WatchlistCurrencyTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/29/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit


class WatchlistCurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonIsFavourite: UIButton!
    @IBOutlet weak var labelPair: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelTradeVolume: UILabel!
    @IBOutlet weak var labelChanges: UILabel!
    
    var data: WatchlistPair? = nil {
        didSet {
            guard let d = data else {
                return
            }
            
            self.buttonIsFavourite.isSelected = d.isFavourite
            self.labelPair.text = (d.name)!
            self.labelPrice.text = String(d.price)

            self.labelTradeVolume.text = String(d.tradeVolume)
            self.labelChanges.text = String(d.changes > 0.0 ? "+" : "-") + String(abs(d.changes))
            self.labelChanges.textColor = d.changes > 0.0 ? UIColor.greenBlue : UIColor.orangePink
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.backgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
