//
//  CHWalletCurrencyHeaderView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletCurrencyHeaderView: UIView {
    
    @IBOutlet fileprivate weak var balanceLabel      : UILabel!
    @IBOutlet fileprivate weak var currencyLabel     : UILabel!
    @IBOutlet fileprivate weak var countInOrdersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
}

// MARK: - Setup

private extension CHWalletCurrencyHeaderView {
    
    func setupUI() {
        balanceLabel.text       = "SCREEN_PASSCODE_BALANCE".localized
        currencyLabel.text      = "SCREEN_WALLET_CURRENCY".localized
        countInOrdersLabel.text = "SCREEN_PASSCODE_IN_ORDERS".localized
    }
    
}
