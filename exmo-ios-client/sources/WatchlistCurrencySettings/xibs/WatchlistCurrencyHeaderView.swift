//
//  CustomTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/29/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

struct WatchlistPair {
    var isFavourite: Bool
    var name: String!
    var price: Double!
    var tradeVolume: Double
    var changes: Double
    
    init(isFavourite: Bool, name: String, price: Double, tradeVolume: Double, changes: Double) {
        self.isFavourite = isFavourite
        self.name = name
        self.price = price
        self.tradeVolume = tradeVolume
        self.changes = changes
    }
}

class WatchlistCurrencyHeaderView: NibView {
    @IBOutlet weak var labelFavourite: UILabel!
    @IBOutlet weak var labelPair: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelTradeVolume: UILabel!
    @IBOutlet weak var labelChanges: UILabel!
}
