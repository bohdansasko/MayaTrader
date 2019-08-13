//
//  CHWalletBalanceView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 4/8/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletBalanceView: UIView {
    @IBOutlet fileprivate weak var btcTextLabel : UILabel!
    @IBOutlet fileprivate weak var btcValueLabel: UILabel!
    @IBOutlet fileprivate weak var usdTextLabel : UILabel!
    @IBOutlet fileprivate weak var usdValueLabel: UILabel!
    @IBOutlet fileprivate weak var currencyDividerImage: UIImageView!
    
    override init(frame: CGRect) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

// MARK: - Setters

extension CHWalletBalanceView {
    
    func set(amountBTC: Double, amountUSD: Double) {
        btcValueLabel.text = "\u{20BF} \(Utils.getFormatedPrice(value: amountBTC))"
        usdValueLabel.text = "$ \(Utils.getFormatedPrice(value: amountUSD))"
    }
    
}
