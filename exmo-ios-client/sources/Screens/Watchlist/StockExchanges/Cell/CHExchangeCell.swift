//
//  CHExchangeCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHExchangeCell: CHBaseCollectionCell {
    @IBOutlet fileprivate weak var iconImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel    : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        nameLabel.text      = nil
    }
    
}

// MARK: - Set methods

extension CHExchangeCell {
    
    func set(exchangeModel: CHExchangeModel) {
        iconImageView.image = exchangeModel.icon
        nameLabel.text      = exchangeModel.name
    }
    
}
