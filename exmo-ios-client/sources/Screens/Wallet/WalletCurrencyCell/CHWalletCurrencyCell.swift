//
//  CHWalletCurrencyCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletCurrencyCell: UITableViewCell {
    @IBOutlet fileprivate weak var balanceLabel      : UILabel!
    @IBOutlet fileprivate weak var currencyLabel     : UILabel!
    @IBOutlet fileprivate weak var countInOrdersLabel: UILabel!
        
}

extension CHWalletCurrencyCell {
    
    func set(_ currencyModel: ExmoWalletCurrency) {
        balanceLabel.text = Utils.getFormatedPrice(value: currencyModel.balance)
        currencyLabel.text = currencyModel.code
        countInOrdersLabel.text = String(currencyModel.countInOrders)
    }
    
}
