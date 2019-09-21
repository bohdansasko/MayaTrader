//
//  WatchlistCardCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol WatchlistCardCellDelegate: class {
    func watchlistCardCell(_ cell: WatchlistCardCell, didTouchFavouriteAt indexPath: IndexPath)
}

final class WatchlistCardCell: CHBaseCollectionCell {
    fileprivate var stockNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 11)
        label.textAlignment = .center
        label.textColor = .dark2
        return label
    }()

    
    fileprivate var pairNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    fileprivate var favButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "icGlobalHeartOff").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "icGlobalHeartOn").withRenderingMode(.alwaysOriginal), for: .selected)
        btn.isSelected = false
        return btn
    }()

    fileprivate var pairBuyPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .dodgerBlue
        return label
    }()
    
    fileprivate var pairSellPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor(red: 193.0/255, green: 45.0/255, blue: 102.0/255, alpha: 1)
        return label
    }()

   fileprivate var pairVolumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .dark2
        return label
    }()

    fileprivate var currencyChangesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .greenBlue
        return label
    }()
    
    fileprivate var currencyFormatter: CHLiteCurrencyFormatter! {
        didSet { refreshLabels() }
    }
    fileprivate var indexPath: IndexPath!
    
    weak var delegate: WatchlistCardCellDelegate?
    
    override func setupUI() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .dark
        
        addSubview(stockNameLabel)
        addSubview(pairNameLabel)
        addSubview(pairBuyPriceLabel)
        addSubview(pairSellPriceLabel)
        addSubview(pairVolumeLabel)
        addSubview(currencyChangesLabel)
        
        setupConstraints()
    }
}

// MARK: - Set

extension WatchlistCardCell {
    
    func set(_ currencyFormatter: CHLiteCurrencyFormatter, indexPath: IndexPath) {
        self.currencyFormatter = currencyFormatter
        self.indexPath = indexPath
    }
    
}

// MARK: - Setup

private extension WatchlistCardCell {
    
    func setupConstraints() {
        stockNameLabel.anchor(self.topAnchor, left: self.leftAnchor,
                             bottom: nil, right: self.rightAnchor,
                             topConstant: 10, leftConstant: 10,
                             bottomConstant: 0, rightConstant: 10,
                             widthConstant: 0, heightConstant: 15)
        
        pairNameLabel.anchor(stockNameLabel.bottomAnchor, left: self.leftAnchor,
                             bottom: nil, right: self.rightAnchor,
                             topConstant: 2, leftConstant: 10,
                             bottomConstant: 0, rightConstant: 10,
                             widthConstant: 0, heightConstant: 15)
        
        pairBuyPriceLabel.anchor(pairNameLabel.bottomAnchor, left: pairNameLabel.leftAnchor,
                                 bottom: nil, right: pairNameLabel.rightAnchor,
                                 topConstant: 5, leftConstant: 5, bottomConstant: 0,
                                 rightConstant: 10, widthConstant: 0, heightConstant: 15)
        
        pairSellPriceLabel.anchor(pairBuyPriceLabel.bottomAnchor, left: pairNameLabel.leftAnchor,
                                  bottom: nil, right: pairNameLabel.rightAnchor,
                                  topConstant: 5, leftConstant: 5,
                                  bottomConstant: 0, rightConstant: 5,
                                  widthConstant: 0, heightConstant: 15)
        
        currencyChangesLabel.anchor(pairSellPriceLabel.bottomAnchor, left: pairNameLabel.leftAnchor,
                                    bottom: nil, right: pairNameLabel.rightAnchor,
                                    topConstant: 5, leftConstant: 5,
                                    bottomConstant: 0, rightConstant: 5,
                                    widthConstant: 0, heightConstant: 15)
        
        pairVolumeLabel.anchor(currencyChangesLabel.bottomAnchor, left: pairNameLabel.leftAnchor,
                               bottom: nil, right: pairNameLabel.rightAnchor,
                               topConstant: 5, leftConstant: 5,
                               bottomConstant: 0, rightConstant: 5,
                               widthConstant: 0, heightConstant: 15)

        addSubview(favButton)
        favButton.addTarget(self, action: #selector(onTouchFavBtn(_:)), for: .touchUpInside)
        favButton.anchor(
                self.topAnchor,
                left: nil,
                bottom: nil,
                right: self.rightAnchor,
                topConstant: 10,
                leftConstant: 0,
                bottomConstant: 0,
                rightConstant: 10,
                widthConstant: 20,
                heightConstant: 20
        )
    }

}

// MARK: - Update cell state

private extension WatchlistCardCell {
    
    func refreshLabels() {
        stockNameLabel.text            = currencyFormatter.stockName
        pairNameLabel.text             = currencyFormatter.currencyName
        pairBuyPriceLabel.text         = currencyFormatter.buyPrice
        pairSellPriceLabel.text        = currencyFormatter.sellPrice
        pairVolumeLabel.text           = currencyFormatter.volume
        currencyChangesLabel.text      = currencyFormatter.changes
        currencyChangesLabel.textColor = currencyFormatter.changesColor
        favButton.isSelected           = currencyFormatter.isFavourite
    }
    
}

// MARK: - Actions

private extension WatchlistCardCell {
    
    @objc func onTouchFavBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.watchlistCardCell(self, didTouchFavouriteAt: indexPath)
    }
    
}
