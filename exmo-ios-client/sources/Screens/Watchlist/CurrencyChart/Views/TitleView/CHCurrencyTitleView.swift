//
//  CHCurrencyTitleView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/2/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHCurrencyTitleView: CHBaseView {
    @IBOutlet fileprivate weak var stockNameLabel   : UILabel!
    @IBOutlet fileprivate weak var currencyNameLabel: UILabel!
}

// MARK: - Setters

extension CHCurrencyTitleView {
    
    func set(stock: String?, currency: String?) {
        stockNameLabel.text = stock
        currencyNameLabel.text = currency
    }
    
}
