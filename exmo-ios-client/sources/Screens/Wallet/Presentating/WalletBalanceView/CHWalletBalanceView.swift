//
//  CHWalletBalanceView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 4/8/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import ObjectMapper

struct CHWalletBalance {
    var btc: Double = 0.0
    var usd: Double = 0.0
    
}

// MARK: - Mappable

extension CHWalletBalance: Mappable {
    
    init?(map: Map) {
        let requiredFields = [ "BTC", "USD" ]
        
        if !map.isJsonValid(by: requiredFields) {
            assertionFailure("required")
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        btc <- map["BTC"]
        usd <- map["USD"]
    }
}

final class CHWalletBalanceView: UIView {
    @IBOutlet fileprivate weak var btcTextLabel : UILabel!
    @IBOutlet fileprivate weak var btcValueLabel: UILabel!
    @IBOutlet fileprivate weak var usdTextLabel : UILabel!
    @IBOutlet fileprivate weak var usdValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
}

// MARK: - Setup

private extension CHWalletBalanceView {
    
    func setupUI() {
        btcTextLabel.text = "CURRENCY_BTC".localized
        usdTextLabel.text = "CURRENCY_USD".localized
        
        set(amountBTC: 0.0, amountUSD: 0.0)
    }
    
}

// MARK: - Setters

extension CHWalletBalanceView {
    
    func set(amountBTC: Double, amountUSD: Double) {
        btcValueLabel.text = "\u{20BF} \(Utils.getFormatedPrice(value: amountBTC))"
        usdValueLabel.text = "$ \(Utils.getFormatedPrice(value: amountUSD))"
    }
    
}
