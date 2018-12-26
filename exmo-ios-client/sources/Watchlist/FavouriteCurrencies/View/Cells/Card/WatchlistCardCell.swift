//
//  WatchlistCardCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import LBTAComponents

class WatchlistCardCell: DatasourceCell {
    var pairNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
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
    
    var backgroundButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()
    
    var callbackOnTouchCell: VoidClosure?

    override var datasourceItem: Any? {
        didSet {
            guard let cm = datasourceItem as? WatchlistCurrency else { return }
            
            pairNameLabel.text = cm.getDisplayCurrencyPairName()
            pairBuyPriceLabel.text = "Buy: " + cm.getBuyAsStr()
            pairSellPriceLabel.text = "Sell: " + cm.getSellAsStr()
            pairVolumeLabel.text = "Volume: " + Utils.getFormatedPrice(value: cm.tickerPair.volume)
            currencyChangesLabel.text = "Changes: " + Utils.getFormatedCurrencyPairChanges(changesValue: cm.tickerPair.getChanges())
            
            currencyChangesLabel.textColor = Utils.getChangesColor(value: cm.tickerPair.getChanges())
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        setupUI()
        setupConstraints()
        setupTouchBackgroundListeners()
    }
}

extension WatchlistCardCell {
    func setupUI() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .dark
        
        addSubview(backgroundButton)
        addSubview(pairNameLabel)
        addSubview(pairBuyPriceLabel)
        addSubview(pairSellPriceLabel)
        addSubview(pairVolumeLabel)
        addSubview(currencyChangesLabel)
    }
    
    func setupTouchBackgroundListeners() {
        backgroundButton.addTarget(self, action: #selector(handleTouchUpInside(_:)), for: .touchUpInside)
        backgroundButton.addTarget(self, action: #selector(setNormalBackground(_:)), for: .touchUpOutside)
        backgroundButton.addTarget(self, action: #selector(setNormalBackground(_:)), for: .touchCancel)
        backgroundButton.addTarget(self, action: #selector(setHighlightedBackground(_:)), for: .touchDown)
    }
    
    func setupConstraints() {
        backgroundButton.fillSuperview()
        
        pairNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 15)
        
        pairBuyPriceLabel.anchor(pairNameLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 15)
        
        pairSellPriceLabel.anchor(pairBuyPriceLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 15)
        
        currencyChangesLabel.anchor(pairSellPriceLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 15)
        
        pairVolumeLabel.anchor(currencyChangesLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 15)
    }
}

extension WatchlistCardCell {
    @objc func handleTouchUpInside(_ sender: Any) {
        setNormalBackground(sender)

        guard let cellDelegate = controller as? CellDelegate else { return }
        cellDelegate.didTouchCell(datasourceItem: datasourceItem)
    }
    
    @objc func setNormalBackground(_ sender: Any) {
        backgroundButton.backgroundColor = UIColor.clear
    }
    
    @objc func setHighlightedBackground(_ sender: Any) {
        backgroundButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
}
