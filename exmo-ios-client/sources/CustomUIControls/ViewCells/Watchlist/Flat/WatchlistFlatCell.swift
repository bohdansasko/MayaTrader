//
//  WatchlistCardCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import LBTAComponents

class WatchlistCardCell: DatasourceCell, WatchlistCell {

    var pairNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    var pairPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 14)
        label.textAlignment = .center
        label.textColor = .dark2
        return label
    }()

    var pairVolumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 12)
        label.textAlignment = .right
        label.textColor = .greenBlue
        return label
    }()

    var currencyChangesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .greenBlue
        return label
    }()
    
    var verticalLineSeparatorImage: UIView = {
        let view = UIView()
        view.backgroundColor = .dark2
        view.frame = CGRect(x: 0, y: 0, width: 1, height: 15)
        return view
    }()

    override var datasourceItem: Any? {
        didSet {
            guard let cm = datasourceItem as? WatchlistCurrencyModel else { return }
            
            self.pairNameLabel.text = cm.getDisplayCurrencyPairName()
            self.pairPriceLabel.text = cm.getPriceAsStr()
            self.pairVolumeLabel.text = Utils.getFormatedPrice(value: cm.volume, maxFractDigits: 4)
            self.currencyChangesLabel.text = Utils.getFormatedCurrencyPairChanges(changesValue: cm.getChanges())
            
            self.pairVolumeLabel.textColor = Utils.getChangesColor(value: cm.getChanges())
            self.currencyChangesLabel.textColor = self.pairVolumeLabel.textColor
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .dark
        
        addSubview(pairNameLabel)
        addSubview(pairPriceLabel)
        addSubview(pairVolumeLabel)
        addSubview(verticalLineSeparatorImage)
        addSubview(currencyChangesLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        pairNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 20)
        pairPriceLabel.anchor(pairNameLabel.bottomAnchor, left: pairNameLabel.leftAnchor, bottom: nil, right: pairNameLabel.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 15)
        
        verticalLineSeparatorImage.anchorCenterXToSuperview()
        verticalLineSeparatorImage.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalLineSeparatorImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        verticalLineSeparatorImage.topAnchor.constraint(equalTo: pairPriceLabel.bottomAnchor, constant: 6).isActive = true
        
        pairVolumeLabel.anchor(verticalLineSeparatorImage.topAnchor, left: pairNameLabel.leftAnchor, bottom: self.bottomAnchor, right: verticalLineSeparatorImage.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 15)
        currencyChangesLabel.anchor(verticalLineSeparatorImage.topAnchor, left: verticalLineSeparatorImage.rightAnchor, bottom: self.bottomAnchor, right: pairNameLabel.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
