//
//  CHWalletCurrenciesListHeader.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/16/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletCurrenciesListHeader: UITableViewHeaderFooterView {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .black
    }
}
