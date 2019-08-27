//
//  CHSearchCurrencyResultCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/21/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol CHSearchCurrencyResultCellDelegate: class {
    func searchCurrencyResultCell(_ cell: CHSearchCurrencyResultCell, didTapFavouriteAt indexPath: IndexPath)
}

final class CHSearchCurrencyResultCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var stockIcon          : UIImageView!
    @IBOutlet fileprivate weak var stockLabel         : UILabel!
    @IBOutlet fileprivate weak var currencyLabel      : UILabel!
    @IBOutlet fileprivate weak var currencyPriceLabel : UILabel!
    @IBOutlet fileprivate weak var currencyVolumeLabel: UILabel!
    @IBOutlet fileprivate weak var selectedButton     : UIButton!
    
    private(set) var indexPath: IndexPath!
    
    weak var delegate: CHSearchCurrencyResultCellDelegate?

}

// MARK: - Setters

extension CHSearchCurrencyResultCell {
    
    func set(indexPath: IndexPath, formatter: CHLiteCurrencyFormatter) {
        self.indexPath           = indexPath
        
        stockIcon.image          = formatter.stockIcon
        stockLabel.text          = formatter.stockName
        currencyLabel.text       = formatter.currencyName
        currencyPriceLabel.text  = formatter.sellPrice
        currencyVolumeLabel.text = formatter.volume
    }
    
    func set(isSelected: Bool) {
        selectedButton.isSelected = isSelected
    }
    
}

// MARK: - Actions

private extension CHSearchCurrencyResultCell {

    @IBAction func actSelect(_ sender: Any) {
        delegate?.searchCurrencyResultCell(self, didTapFavouriteAt: indexPath)
    }
    
}
