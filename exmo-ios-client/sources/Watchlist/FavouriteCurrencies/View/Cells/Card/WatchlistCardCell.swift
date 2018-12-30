//
//  WatchlistCardCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import LBTAComponents

class WatchlistCardCell: ExmoCollectionCell {
    var pairNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    var favButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "icGlobalHeartOff").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "icGlobalHeartOn").withRenderingMode(.alwaysOriginal), for: .selected)
        btn.isSelected = true
        return btn
    }()

    var pairBuyPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .dodgerBlue
        return label
    }()
    
    var pairSellPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .orangePink
        return label
    }()

    var pairVolumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .dark2
        return label
    }()

    var currencyChangesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .greenBlue
        return label
    }()

    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? UIColor.white.withAlphaComponent(0.1) : .clear
        }
    }

    override var datasourceItem: Any? {
        didSet {
            guard let cm = datasourceItem as? WatchlistCurrency else { return }
            
            pairNameLabel.text = cm.getDisplayCurrencyPairName()
            pairBuyPriceLabel.text = "Buy: " + cm.getBuyAsStr()
            pairSellPriceLabel.text = "Sell: " + cm.getSellAsStr()
            pairVolumeLabel.text = "Volume: " + Utils.getFormatedPrice(value: cm.tickerPair.volume)
            currencyChangesLabel.text = "Changes: " + Utils.getFormatedCurrencyPairChanges(changesValue: cm.tickerPair.getChanges())
            currencyChangesLabel.textColor = Utils.getChangesColor(value: cm.tickerPair.getChanges())
            favButton.isSelected = cm.tickerPair.isFavourite
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        setupUI()
        setupConstraints()
    }
}

extension WatchlistCardCell {
    func setupUI() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .dark
        
        addSubview(pairNameLabel)

        addSubview(pairBuyPriceLabel)
        addSubview(pairSellPriceLabel)
        addSubview(pairVolumeLabel)
        addSubview(currencyChangesLabel)
    }

    func setupConstraints() {
        pairNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 15)
        
        pairBuyPriceLabel.anchor(pairNameLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 15)
        
        pairSellPriceLabel.anchor(pairBuyPriceLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 15)
        
        currencyChangesLabel.anchor(pairSellPriceLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 15)
        
        pairVolumeLabel.anchor(currencyChangesLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 15)

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

    @objc func onTouchFavBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didTouchCell(datasourceItem: datasourceItem)
    }
}
